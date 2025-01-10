/*
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

 package com.google.ar.core.examples.java.augmentedimage;


 import android.content.Context;
 import android.graphics.Bitmap;
 import android.graphics.BitmapFactory;
 import android.graphics.Color;
 import android.net.Uri;
 import android.opengl.GLES20;
 import android.opengl.GLES20;
 import android.opengl.GLSurfaceView;
 import android.opengl.Matrix;
 import android.os.Bundle;
 import android.util.Log;
 import android.util.Pair;
 import android.util.TypedValue;
 import android.view.MotionEvent;
 import android.view.View;
 import android.widget.ImageButton;
 import android.widget.ImageView;
 import android.widget.LinearLayout;
 import android.widget.TextView;
 import android.widget.Toast;
 import androidx.annotation.NonNull;
 import androidx.annotation.Nullable;
 import androidx.appcompat.app.AppCompatActivity;
 import androidx.constraintlayout.widget.ConstraintLayout;
 import com.bumptech.glide.Glide;
 import com.bumptech.glide.RequestManager;
 import com.example.vitral_app.MyCallback;
 import com.example.vitral_app.R;
 import com.example.vitral_app.StainedGlass;
 import com.example.vitral_app.StainedGlassInfo;
 import com.google.android.gms.tasks.OnCompleteListener;
 import com.google.android.gms.tasks.Task;
 import com.google.android.gms.tasks.Tasks;
 import com.google.ar.core.Anchor;
 import com.google.ar.core.ArCoreApk;
 import com.google.ar.core.AugmentedImage;
 import com.google.ar.core.AugmentedImageDatabase;
 import com.google.ar.core.Camera;
 import com.google.ar.core.Config;
 import com.google.ar.core.Frame;
 import com.google.ar.core.HitResult;
 import com.google.ar.core.Plane;
 import com.google.ar.core.Pose;
 import com.google.ar.core.Session;
 import com.google.ar.core.Trackable;
 import com.google.ar.core.examples.java.augmentedimage.rendering.AugmentedImageRenderer;
 import com.google.ar.core.examples.java.common.helpers.CameraPermissionHelper;
 import com.google.ar.core.examples.java.common.helpers.DisplayRotationHelper;
 import com.google.ar.core.examples.java.common.helpers.FullScreenHelper;
 import com.google.ar.core.examples.java.common.helpers.SnackbarHelper;
 import com.google.ar.core.examples.java.common.helpers.TapHelper;
 import com.google.ar.core.examples.java.common.helpers.TrackingStateHelper;
 import com.google.ar.core.examples.java.common.rendering.BackgroundRenderer;
 import com.google.ar.core.exceptions.CameraNotAvailableException;
 import com.google.ar.core.exceptions.UnavailableApkTooOldException;
 import com.google.ar.core.exceptions.UnavailableArcoreNotInstalledException;
 import com.google.ar.core.exceptions.UnavailableSdkTooOldException;
 import com.google.ar.core.exceptions.UnavailableUserDeclinedInstallationException;
 import com.google.firebase.firestore.CollectionReference;
 import com.google.firebase.firestore.DocumentReference;
 import com.google.firebase.firestore.DocumentSnapshot;
 import com.google.firebase.firestore.FieldPath;
 import com.google.firebase.firestore.FirebaseFirestore;
 import com.google.firebase.firestore.QuerySnapshot;
 import java.io.IOException;
 import java.io.InputStream;
 import java.nio.ByteBuffer;
 import java.nio.ByteOrder;
 import java.nio.FloatBuffer;
 import java.nio.ShortBuffer;
 import java.util.ArrayList;
 import java.util.Collection;
 import java.util.HashMap;
 import java.util.List;
 import java.util.Map;
 import javax.microedition.khronos.egl.EGLConfig;
 import javax.microedition.khronos.opengles.GL10;
 /**
  * This app extends the HelloAR Java app to include image tracking functionality.
  *
  * <p>In this example, we assume all images are static or moving slowly with a large occupation of
  * the screen. If the target is actively moving, we recommend to check
  * AugmentedImage.getTrackingMethod() and render only when the tracking method equals to
  * FULL_TRACKING. See details in <a
  * href="https://developers.google.com/ar/develop/java/augmented-images/">Recognize and Augment
  * Images</a>.
  */
 public class AugmentedImageActivity extends AppCompatActivity implements GLSurfaceView.Renderer {
   private static final String TAG = AugmentedImageActivity.class.getSimpleName();
 
   // Rendering. The Renderers are created here, and initialized when the GL surface is created.
   private GLSurfaceView surfaceView;
   private ImageButton goBackButton;
   private ConstraintLayout funfactButton;
   private ConstraintLayout productionButton;
   private ConstraintLayout creditsButton;
   private ConstraintLayout meaningButton;
   private RequestManager glideRequestManager;
   private ImageView arPlaceholderView;
   private ConstraintLayout infoCardView;
   private TextView infoCardCategoryView;
   private TextView infoCardTitleView;
   private TextView infoCardDescriptionView;
   private ImageView infoCardImageView;
 
   private boolean installRequested;
 
   private Session session;
   private final SnackbarHelper messageSnackbarHelper = new SnackbarHelper();
   private DisplayRotationHelper displayRotationHelper;
   private final TrackingStateHelper trackingStateHelper = new TrackingStateHelper(this);
   private TapHelper tapHelper;
 
   private final BackgroundRenderer backgroundRenderer = new BackgroundRenderer();
   private final AugmentedImageRenderer augmentedImageRenderer = new AugmentedImageRenderer();
 
   private final List <StainedGlassInfo> stainedGlassInfos = new ArrayList<>();
   private boolean madeApiCall = false;
   private final List <StainedGlassInfo> filteredStainedGlassInfos = new ArrayList<>();
   private String selectedCategory = "";
   private int selectedInfoIndex = -1;
 
   private boolean shouldConfigureSession = false;
 
   // Augmented image configuration and rendering.
   // Load a single image (true) or a pre-generated image database (false).
   private final boolean useSingleImage = true;
   // Augmented image and its associated center pose anchor, keyed by index of the augmented image in
   // the
   // database.
   private final Map<Integer, Pair<AugmentedImage, Anchor>> augmentedImageMap = new HashMap<>();
 
   @Override
   protected void onCreate(Bundle savedInstanceState) {
     super.onCreate(savedInstanceState);
     setContentView(R.layout.activity_main);
     surfaceView = findViewById(R.id.surfaceview);
     displayRotationHelper = new DisplayRotationHelper(/*context=*/ this);
 
     tapHelper = new TapHelper(/* context= */ this);
     surfaceView.setOnTouchListener(tapHelper);
 
     // Set up renderer.
     surfaceView.setPreserveEGLContextOnPause(true);
     surfaceView.setEGLContextClientVersion(2);
     surfaceView.setEGLConfigChooser(8, 8, 8, 8, 16, 0); // Alpha used for plane blending.
     surfaceView.setRenderer(this);
     surfaceView.setRenderMode(GLSurfaceView.RENDERMODE_CONTINUOUSLY);
     surfaceView.setWillNotDraw(false);
 
 
     // Init UI Elements
     arPlaceholderView = findViewById(R.id.ar_placeholder);
 
     goBackButton = findViewById(R.id.goBackButton);
     goBackButton.setOnClickListener(new View.OnClickListener() {
       @Override
       public void onClick(View v) {
         finish();
       }
     });
 
     funfactButton = findViewById(R.id.funfact_button);
     funfactButton.setOnClickListener(new View.OnClickListener() {
       @Override
       public void onClick(View v) {
         onCategorySelected(v, "funfact");
       }
     });
     productionButton = findViewById(R.id.production_button);
     productionButton.setOnClickListener(new View.OnClickListener() {
       @Override
       public void onClick(View v) {
         onCategorySelected(v, "production");
       }
     });
     creditsButton = findViewById(R.id.credits_button);
     creditsButton.setOnClickListener(new View.OnClickListener() {
       @Override
       public void onClick(View v) {
         onCategorySelected(v, "credits");
       }
     });
     meaningButton = findViewById(R.id.meaning_button);
     meaningButton.setOnClickListener(new View.OnClickListener() {
       @Override
       public void onClick(View v) {
         onCategorySelected(v, "meaning");
       }
     });
 
     unselectCategoryButtons();
 
     infoCardView = findViewById(R.id.info_card);
     infoCardCategoryView = findViewById(R.id.info_card_category);
     infoCardTitleView = findViewById(R.id.info_card_title);
     infoCardDescriptionView = findViewById(R.id.info_card_description);
     infoCardImageView = findViewById(R.id.info_card_image);
 
     infoCardView.setVisibility(View.INVISIBLE);
 
     installRequested = false;
   }
 
   @Override
   protected void onDestroy() {
     if (session != null) {
       // Explicitly close ARCore Session to release native resources.
       // Review the API reference for important considerations before calling close() in apps with
       // more complicated lifecycle requirements:
       // https://developers.google.com/ar/reference/java/arcore/reference/com/google/ar/core/Session#close()
       session.close();
       session = null;
     }
 
     super.onDestroy();
   }
 
   @Override
   protected void onResume() {
     super.onResume();
 
     if (session == null) {
       Exception exception = null;
       String message = null;
       try {
         switch (ArCoreApk.getInstance().requestInstall(this, !installRequested)) {
           case INSTALL_REQUESTED:
             installRequested = true;
             return;
           case INSTALLED:
             break;
         }
 
         // ARCore requires camera permissions to operate. If we did not yet obtain runtime
         // permission on Android M and above, now is a good time to ask the user for it.
         if (!CameraPermissionHelper.hasCameraPermission(this)) {
           CameraPermissionHelper.requestCameraPermission(this);
           return;
         }
 
         session = new Session(/* context = */ this);
       } catch (UnavailableArcoreNotInstalledException
           | UnavailableUserDeclinedInstallationException e) {
         message = "Please install ARCore";
         exception = e;
       } catch (UnavailableApkTooOldException e) {
         message = "Please update ARCore";
         exception = e;
       } catch (UnavailableSdkTooOldException e) {
         message = "Please update this app";
         exception = e;
       } catch (Exception e) {
         message = "This device does not support AR";
         exception = e;
       }
 
       if (message != null) {
         messageSnackbarHelper.showError(this, message);
         Log.e(TAG, "Exception creating session", exception);
         return;
       }
 
       shouldConfigureSession = true;
     }
 
     if (shouldConfigureSession) {
       configureSession();
       shouldConfigureSession = false;
     }
 
     // Note that order matters - see the note in onPause(), the reverse applies here.
     try {
       session.resume();
     } catch (CameraNotAvailableException e) {
       messageSnackbarHelper.showError(this, "Camera not available. Try restarting the app.");
       session = null;
       return;
     }
     surfaceView.onResume();
     displayRotationHelper.onResume();
 
     arPlaceholderView.setVisibility(View.VISIBLE);
   }
 
   @Override
   public void onPause() {
     super.onPause();
     if (session != null) {
       // Note that the order matters - GLSurfaceView is paused first so that it does not try
       // to query the session. If Session is paused before GLSurfaceView, GLSurfaceView may
       // still call session.update() and get a SessionPausedException.
       displayRotationHelper.onPause();
       surfaceView.onPause();
       session.pause();
     }
   }
 
   @Override
   public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] results) {
     super.onRequestPermissionsResult(requestCode, permissions, results);
     if (!CameraPermissionHelper.hasCameraPermission(this)) {
       Toast.makeText(
               this, "Camera permissions are needed to run this application", Toast.LENGTH_LONG)
           .show();
       if (!CameraPermissionHelper.shouldShowRequestPermissionRationale(this)) {
         // Permission denied with checking "Do not ask again".
         CameraPermissionHelper.launchPermissionSettings(this);
       }
       finish();
     }
   }
 
   @Override
   public void onWindowFocusChanged(boolean hasFocus) {
     super.onWindowFocusChanged(hasFocus);
     FullScreenHelper.setFullScreenOnWindowFocusChanged(this, hasFocus);
   }
 
   @Override
   public void onSurfaceCreated(GL10 gl, EGLConfig config) {
     GLES20.glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
 
     // Prepare the rendering objects. This involves reading shaders, so may throw an IOException.
     try {
       // Create the texture and pass it to ARCore session to be filled during update().
       backgroundRenderer.createOnGlThread(/*context=*/ this);
       augmentedImageRenderer.initialize();
     } catch (IOException e) {
       Log.e(TAG, "Failed to read an asset file", e);
     }
   }
 
   @Override
   public void onSurfaceChanged(GL10 gl, int width, int height) {
     displayRotationHelper.onSurfaceChanged(width, height);
     GLES20.glViewport(0, 0, width, height);
   }
 
   @Override
   public void onDrawFrame(GL10 gl) {
     // Clear screen to notify driver it should not load any pixels from previous frame.
     GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT | GLES20.GL_DEPTH_BUFFER_BIT);
 
     if (session == null) {
       return;
     }
     // Notify ARCore session that the view size changed so that the perspective matrix and
     // the video background can be properly adjusted.
     displayRotationHelper.updateSessionIfNeeded(session);
 
     handleTap();
 
     try {
       session.setCameraTextureName(backgroundRenderer.getTextureId());
 
       // Obtain the current frame from ARSession. When the configuration is set to
       // UpdateMode.BLOCKING (it is by default), this will throttle the rendering to the
       // camera framerate.
       Frame frame = session.update();
       Camera camera = frame.getCamera();
 
       // Keep the screen unlocked while tracking, but allow it to lock when tracking stops.
       trackingStateHelper.updateKeepScreenOnFlag(camera.getTrackingState());
 
       // If frame is ready, render camera preview image to the GL surface.
       backgroundRenderer.draw(frame);
 
       // Get projection matrix.
       float[] projmtx = new float[16];
       camera.getProjectionMatrix(projmtx, 0, 0.1f, 100.0f);
 
       // Get camera matrix and draw.
       float[] viewmtx = new float[16];
       camera.getViewMatrix(viewmtx, 0);
 
       // Compute lighting from average intensity of the image.
       final float[] colorCorrectionRgba = new float[4];
       frame.getLightEstimate().getColorCorrection(colorCorrectionRgba, 0);
 
       // Visualize augmented images.
       drawAugmentedImages(frame, projmtx, viewmtx, colorCorrectionRgba);
 
     } catch (Throwable t) {
       // Avoid crashing the application due to unhandled exceptions.
       Log.e(TAG, "Exception on the OpenGL thread", t);
     }
   }
 
   private void configureSession() {
     Config config = new Config(session);
     config.setFocusMode(Config.FocusMode.AUTO);
     if (!setupAugmentedImageDatabase(config)) {
       messageSnackbarHelper.showError(this, "Could not setup augmented image database");
     }
     session.configure(config);
   }
 
   // MARK: - Image Tracking
   private void drawAugmentedImages(
       Frame frame, float[] projmtx, float[] viewmtx, float[] colorCorrectionRgba) {
     Collection<AugmentedImage> updatedAugmentedImages =
         frame.getUpdatedTrackables(AugmentedImage.class);
 
     // Iterate to update augmentedImageMap, remove elements we cannot draw.
     for (AugmentedImage augmentedImage : updatedAugmentedImages) {
       switch (augmentedImage.getTrackingState()) {
         case PAUSED:
           // When an image is in PAUSED state, but the camera is not PAUSED, it has been detected,
           // but not yet tracked.
           break;
 
         case TRACKING:
           // Have to switch to UI Thread to update View.
           this.runOnUiThread(
               new Runnable() {
                 @Override
                 public void run() {
                   arPlaceholderView.setVisibility(View.GONE);
                 }
               });
             
           String imageName = augmentedImage.getName();
 
           getAPIObjects();
           if (selectedCategory == "") {
            onCategorySelected(findViewById(R.id.funfact_button), "funfact");
           }

           if (!stainedGlassInfos.isEmpty()) {
             filterStainedGlassInfosBy(selectedCategory);
           }
           
 
           // Create a new anchor for newly found images.
           if (!augmentedImageMap.containsKey(augmentedImage.getIndex())) {
             Anchor centerPoseAnchor = augmentedImage.createAnchor(augmentedImage.getCenterPose());
             augmentedImageMap.put(
                 augmentedImage.getIndex(), Pair.create(augmentedImage, centerPoseAnchor));
           }
           break;
 
         case STOPPED:
           augmentedImageMap.remove(augmentedImage.getIndex());
           break;
 
         default:
           break;
       }
     }
 
     // Draw all images in augmentedImageMap
     for (Pair<AugmentedImage, Anchor> pair : augmentedImageMap.values()) {
       AugmentedImage augmentedImage = pair.first;
       Anchor centerAnchor = augmentedImageMap.get(augmentedImage.getIndex()).second;
       switch (augmentedImage.getTrackingState()) {
         case TRACKING:
          Log.d(TAG, "Selected Category: " + selectedCategory);
          Log.d(TAG, "Filtered Stained Glass Infos: " + filteredStainedGlassInfos.size());
          if (selectedCategory != "" && !filteredStainedGlassInfos.isEmpty()) {
            for (StainedGlassInfo info : filteredStainedGlassInfos) {
              float x = info.getPosition().get(0).floatValue();
              float z = info.getPosition().get(1).floatValue();

              String id = info.getCategory() + "_" + info.getTitle();

              augmentedImageRenderer.drawMarker(id, x, z, augmentedImage, frame, centerAnchor, viewmtx, projmtx);
            }
          }
 
          break;
         default:
           break;
       }
     }
   }

   // MARK: - Tap Handling
   
   public void handleTap() {
 
     MotionEvent tap = tapHelper.poll();
     if (tap == null) {
       return;
     }
 
     Log.d(TAG, "handleTap - tap not null");
 
     Frame frame;
     try {
       frame = session.update();
     } catch (CameraNotAvailableException e) {
       Log.e(TAG, "Camera not available during onDrawFrame", e);
       messageSnackbarHelper.showError(this, "Camera not available. Try restarting the app.");
       return;
     } 
 
     // Perform hit test on the frame
     List<HitResult> hitResults = frame.hitTest(tap);
 
     Log.d(TAG, "Hit Test Performed: " + hitResults.size());
 
     // Ensure there are hit results from the tap
     if (hitResults == null || hitResults.isEmpty()) {
       return;
     }
 
     // Log tap x and y
     Log.d(TAG, "Tap x: " + tap.getX() + " y: " + tap.getY());
   
     for (HitResult hit : hitResults) {
       Trackable trackable = hit.getTrackable();
 
       Log.d(TAG, "Hit trackable " + trackable);
 
       if (trackable instanceof AugmentedImage) {
         // Check if the hit is on an augmented image
         AugmentedImage augmentedImage = (AugmentedImage) trackable;
         Log.d(TAG, "Hit augmented image " + augmentedImage.getName());
 
         Anchor[] anchors = augmentedImage.getAnchors().toArray(new Anchor[0]);
        
          if (anchors.length == 0) {
            return;
          }
         Pose inverseAnchorPose = anchors[0].getPose().inverse();
 
         // Identify the tap on a anchor
         for (Anchor anchor : augmentedImage.getAnchors()) {
           Pose anchorPose = anchor.getPose();
           float[] anchorTranslation = new float[3];
           anchorPose.getTranslation(anchorTranslation, 0);
           Log.d(TAG, "Tapped Anchor translation: " + anchorTranslation[0] + " " + anchorTranslation[1] + " " + anchorTranslation[2]);
         }
 
         Pose hitPose = hit.getHitPose();
 
         Pose localHitPose = inverseAnchorPose.compose(hitPose);
 
         float[] translation = localHitPose.getTranslation();
 
         Log.d(TAG, "x: " + translation[0] / augmentedImage.getExtentX() + ", z: " + translation[2] / augmentedImage.getExtentZ());

         for (int i = 0; i < filteredStainedGlassInfos.size(); i++) {
           StainedGlassInfo info = filteredStainedGlassInfos.get(i);
           float x = info.getPosition().get(0).floatValue();
           float z = info.getPosition().get(1).floatValue();
           float dx = translation[0] / (augmentedImage.getExtentX()/2.0f) - x;
           float dz = translation[2] / (augmentedImage.getExtentZ()/2.0f) - z;
           float distance = (float) Math.sqrt(dx * dx + dz * dz);
           if (distance < 0.1f) {
             Log.d(TAG, "Tapped on info: " + info.getTitle());
             selectedInfoIndex = i;
             onInfoSelected();
             return;
           }
         }
         return;
       }
     }
   }

   // MARK: - Augmented Image Setup
 
   private boolean setupAugmentedImageDatabase(Config config) {
     AugmentedImageDatabase augmentedImageDatabase;
 
     // There are two ways to configure an AugmentedImageDatabase:
     // 1. Add Bitmap to DB directly
     // 2. Load a pre-built AugmentedImageDatabase
     // Option 2) has
     // * shorter setup time
     // * doesn't require images to be packaged in apk.
     if (useSingleImage) {
       Bitmap augmentedImageBitmap = loadAugmentedImageBitmap();
       if (augmentedImageBitmap == null) {
         return false;
       }
 
       augmentedImageDatabase = new AugmentedImageDatabase(session);
       augmentedImageDatabase.addImage("pib_paes_peixes", augmentedImageBitmap);
       // If the physical size of the image is known, you can instead use:
       //     augmentedImageDatabase.addImage("image_name", augmentedImageBitmap, widthInMeters);
       // This will improve the initial detection speed. ARCore will still actively estimate the
       // physical size of the image as it is viewed from multiple viewpoints.
     } else {
       // This is an alternative way to initialize an AugmentedImageDatabase instance,
       // load a pre-existing augmented image database.
       try (InputStream is = getAssets().open("sample_database.imgdb")) {
         augmentedImageDatabase = AugmentedImageDatabase.deserialize(session, is);
       } catch (IOException e) {
         Log.e(TAG, "IO exception loading augmented image database.", e);
         return false;
       }
     }
 
     config.setAugmentedImageDatabase(augmentedImageDatabase);
     return true;
   }
 
   private Bitmap loadAugmentedImageBitmap() {
     try (InputStream is = getAssets().open("default.jpg")) {
       return BitmapFactory.decodeStream(is);
     } catch (IOException e) {
       Log.e(TAG, "IO exception loading augmented image bitmap.", e);
     }
     return null;
   }
   
   // MARK: - API methods
 
   public static void fetchStainedGlass(String id, MyCallback<StainedGlass> listener) {
     DocumentReference stainedGlassRef = FirebaseFirestore.getInstance()
             .collection("stained-glasses")
             .document(id);
 
       stainedGlassRef.get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
         @Override
         public void onComplete(@NonNull Task<DocumentSnapshot> task) {
           if (task.isSuccessful()) {
             DocumentSnapshot snapshot = task.getResult();
             if (snapshot != null && snapshot.exists()) {
               StainedGlass stainedGlass = StainedGlass.fromMap(snapshot.getData());
               Log.d("StainedGlassAPI", "API Fetched StainedGlass: " + stainedGlass);
               listener.onSuccess(stainedGlass);
             } else {
               Log.d("StainedGlassAPI", "API Document does not exist or contains no data.");
               // listener.onSuccess(null);
             }
           } else {
             Log.e("StainedGlassAPI", "API Failed to fetch stained glass: ", task.getException());
             // listener.onSuccess(null);
           }
         }});
   }
 
   public static void fetchStainedGlassesInfo(List<String> ids, MyCallback<List<StainedGlassInfo>> listener) {
     if (ids.isEmpty()) {
         Log.e("StainedGlassAPI", "Error: IDs list is empty");
         listener.onSuccess(new ArrayList<>());
         return;
     }
 
     CollectionReference stainedGlassesRef = FirebaseFirestore.getInstance().collection("stained-glass-info");
 
     stainedGlassesRef.whereIn(FieldPath.documentId(), ids)
             .get()
             .addOnCompleteListener(new OnCompleteListener<QuerySnapshot>() {
               @Override
               public void onComplete(@NonNull Task<QuerySnapshot> task) {
                 if (task.isSuccessful()) {
                   List<StainedGlassInfo> stainedGlassesList = new ArrayList<>();
                   for (DocumentSnapshot doc : task.getResult().getDocuments()) {
                     try {
                       stainedGlassesList.add(StainedGlassInfo.fromMap(doc.getData()));
                     } catch (Exception e) {
                       Log.e("StainedGlassAPI", "Error parsing document: ", e);
                     }
                   }
                   listener.onSuccess(stainedGlassesList);
                 } else {
                   Log.e("StainedGlassAPI", "Failed to fetch stained glasses info: ", task.getException());
                   listener.onSuccess(new ArrayList<>());
                 }
               }
             });
   }
   
 
   public void getAPIObjects() {
     if (madeApiCall) {
       return;
     }
 
     madeApiCall = true;
 
     Log.d("API", "API Fetching StainedGlass");
     fetchStainedGlass("pib_paes_peixes", new MyCallback<StainedGlass>(){ 
         @Override
         public void onSuccess(StainedGlass stainedGlass) {
           if (stainedGlass != null) {
               Log.d("MainActivity", "API Fetched StainedGlass 2: " + stainedGlass.getTitle());
               List<String> ids = stainedGlass.getInformationIds();
               fetchStainedGlassesInfo(ids, new MyCallback<List<StainedGlassInfo>>(){
                   @Override
                   public void onSuccess(List<StainedGlassInfo> stainedGlassesList) {
                       for (StainedGlassInfo info : stainedGlassesList) {
                           Log.d("MainActivity", "API Fetched StainedGlassInfo 2: " + info.getTitle() + " " + info.getCategory());
                       }
 
                       stainedGlassInfos.addAll(stainedGlassesList);
                   }
 
                   @Override
                   public void onFailure(@Nullable String error) {
                       Log.d("MainActivity", "API onFailure 2: " + error);
                   }
               });
 
           } else {
               Log.d("MainActivity", "API No document found.");
           }
         }
 
         @Override
         public void onFailure(@Nullable String error) {
           Log.d("MainActivity", "API onFailure: " + error);
         }
       });
   }

   // MARK: - Displaying Logic

  public void filterStainedGlassInfosBy(String category) {
    filteredStainedGlassInfos.clear();
    for (StainedGlassInfo info : stainedGlassInfos) {
      if (info.getCategory().equals(category)) {
        filteredStainedGlassInfos.add(info);
      }
    }

    for (StainedGlassInfo info : filteredStainedGlassInfos) {
      Log.d("StainedGlassAPI", "API Filtered StainedGlassInfo: " + info.getTitle() + " " + info.getCategory());
    }
  }

  public void onCategorySelected(View view, String category) {
    // selectedCategory = getResources().getResourceEntryName(view.getId()).replace("_button", "");
    selectedCategory = category;

    selectedInfoIndex = -1;
    
    Log.d("StainedGlassUI", "UI Category Selected: " + selectedCategory);

    unselectCategoryButtons();

    int resId = getResources().getIdentifier(selectedCategory + "_underline", "id", getPackageName());

    filterStainedGlassInfosBy(selectedCategory);

    this.runOnUiThread(
      new Runnable() {
        @Override
        public void run() {
          findViewById(resId).setVisibility(View.VISIBLE);
          infoCardView.setVisibility(View.INVISIBLE);
        }
      });

  }

  public void unselectCategoryButtons() {

    View funfactUnderline = findViewById(R.id.funfact_underline);
    View productionUnderline = findViewById(R.id.production_underline);
    View creditsUnderline = findViewById(R.id.credits_underline);
    View meaningUnderline = findViewById(R.id.meaning_underline);

    this.runOnUiThread(
      new Runnable() {
        @Override
        public void run() {
          funfactUnderline.setVisibility(View.INVISIBLE);
          productionUnderline.setVisibility(View.INVISIBLE);
          creditsUnderline.setVisibility(View.INVISIBLE);
          meaningUnderline.setVisibility(View.INVISIBLE);
        }
      });
  }

  public void onInfoSelected() {
    if (selectedCategory == "" || filteredStainedGlassInfos.isEmpty()) {
      return;
    } 

    StainedGlassInfo info = filteredStainedGlassInfos.get(selectedInfoIndex);

    glideRequestManager = Glide.with(this);

    // run on UI thread
    this.runOnUiThread(
      new Runnable() {
        @Override
        public void run() {
          infoCardView.setVisibility(View.VISIBLE);
          infoCardCategoryView.setText(info.getCategoryText());
          infoCardCategoryView.setBackgroundColor(Color.parseColor(info.getCategoryColor()));
          infoCardCategoryView.setTextColor(Color.parseColor(info.getTextColorForCategory()));
          infoCardTitleView.setText(info.getTitle());
          infoCardDescriptionView.setText(info.getDescription());

          if (info.getImageUrl() != null) {

            int size = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 100, getResources().getDisplayMetrics());
            infoCardImageView.setLayoutParams(new LinearLayout.LayoutParams(size, size));
            
            glideRequestManager.load(info.getImageUrl()).into(infoCardImageView);
          } else {
            infoCardImageView.setLayoutParams(new LinearLayout.LayoutParams(0,0));
            infoCardImageView.setImageDrawable(null);
          }
        }
      });
  }
}
 
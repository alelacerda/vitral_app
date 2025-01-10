package com.google.ar.core.examples.java.augmentedimage.rendering;

import android.opengl.GLES20;
import android.opengl.Matrix;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;
import com.google.ar.core.Frame;
import android.util.Log;
import android.content.Context;
import com.google.ar.core.Anchor;
import com.google.ar.core.AugmentedImage;
import com.google.ar.core.Pose;
import com.google.ar.core.examples.java.common.rendering.ObjectRenderer;
import com.google.ar.core.examples.java.common.rendering.ObjectRenderer.BlendMode;
import java.io.IOException;
import java.util.HashMap;
import com.google.ar.core.Session;

/** Renders an augmented image. */
public class AugmentedImageRenderer {
  private static final String TAG = "AugmentedImageRenderer";

  private static final float TINT_INTENSITY = 0.1f;
  private static final float TINT_ALPHA = 1.0f;
  private static final int[] TINT_COLORS_HEX = {
    0x000000, 0xF44336, 0xE91E63, 0x9C27B0, 0x673AB7, 0x3F51B5, 0x2196F3, 0x03A9F4, 0x00BCD4,
    0x009688, 0x4CAF50, 0x8BC34A, 0xCDDC39, 0xFFEB3B, 0xFFC107, 0xFF9800,
  };

  public final HashMap<String, Anchor> anchorMap = new HashMap<>();

  private FloatBuffer vertexBuffer;
  private ShortBuffer indexBuffer;

  // Definição dos vértices e índices para o quadrado
  private static final float[] VERTICES = {
          -0.01f,  0.0f, -0.01f,  // Inferior esquerdo
           0.01f,  0.0f, -0.01f,  // Inferior direito
           0.01f,  0.0f, 0.01f,  // Superior direito
          -0.01f,  0.0f, 0.01f   // Superior esquerdo
  };

  private static final short[] INDICES = { 0, 1, 2, 0, 2, 3 };


  // Shaders como strings
  private static final String VERTEX_SHADER_CODE =
      "uniform mat4 uModelViewProjectionMatrix;\n" +
      "attribute vec4 aPosition;\n" +
      "\n" +
      "void main() {\n" +
      "    gl_Position = uModelViewProjectionMatrix * aPosition;\n" +
      "}\n";

  private static final String FRAGMENT_SHADER_CODE =
      "precision mediump float;\n" +
      "uniform vec4 uColor;\n" +
      "\n" +
      "void main() {\n" +
      "    gl_FragColor = uColor;\n" +
      "}\n";

  private int program;

  public AugmentedImageRenderer() {
      // Carregar buffers
      vertexBuffer = ByteBuffer.allocateDirect(VERTICES.length * 4)
          .order(ByteOrder.nativeOrder())
          .asFloatBuffer();
      vertexBuffer.put(VERTICES).position(0);

      indexBuffer = ByteBuffer.allocateDirect(INDICES.length * 2)
          .order(ByteOrder.nativeOrder())
          .asShortBuffer();
      indexBuffer.put(INDICES).position(0);

  }

  public void initialize() {
    // Compilar os shaders
    int vertexShader = GLES20.glCreateShader(GLES20.GL_VERTEX_SHADER);
    GLES20.glShaderSource(vertexShader, VERTEX_SHADER_CODE);
    GLES20.glCompileShader(vertexShader);
    checkShaderCompile(vertexShader);

    int fragmentShader = GLES20.glCreateShader(GLES20.GL_FRAGMENT_SHADER);
    GLES20.glShaderSource(fragmentShader, FRAGMENT_SHADER_CODE);
    GLES20.glCompileShader(fragmentShader);
    checkShaderCompile(fragmentShader);

    // Criar o programa OpenGL
    program = GLES20.glCreateProgram();
    GLES20.glAttachShader(program, vertexShader);
    GLES20.glAttachShader(program, fragmentShader);
    GLES20.glLinkProgram(program);
    checkProgramLink(program);

    Log.d("AugmentedImageActivity", "Program: " + program);
  }

  public void drawMarker(String id, float x, float z, AugmentedImage augmentedImage, Frame frame, Anchor centerAnchor, float[] viewMatrix, float[] projectionMatrix) {

    Pose localBoundaryPose = Pose.makeTranslation(
      x * (augmentedImage.getExtentX()/2.0f),
      0.0f,
      z * (augmentedImage.getExtentZ()/2.0f));
    
    Pose anchorPose = centerAnchor.getPose();
    Pose worldBoundaryPose = anchorPose.compose(localBoundaryPose);
    
    float[] modelMatrix = new float[16];
    worldBoundaryPose.toMatrix(modelMatrix,0);

    if (!anchorMap.containsKey(id)) {
      Anchor boundaryAnchor = augmentedImage.createAnchor(worldBoundaryPose);
      anchorMap.put(id, boundaryAnchor);
    }

    // Multiplicar as matrizes para obter o modelo de projeção final
    float[] modelViewProjectionMatrix = new float[16];
    Matrix.multiplyMM(modelViewProjectionMatrix, 0, viewMatrix, 0, modelMatrix, 0);
    Matrix.multiplyMM(modelViewProjectionMatrix, 0, projectionMatrix, 0, modelViewProjectionMatrix, 0);

    // Usar o programa OpenGL
    GLES20.glUseProgram(program);

    // Passar a matriz de modelo e projeção
    int mvpMatrixHandle = GLES20.glGetUniformLocation(program, "uModelViewProjectionMatrix");
    GLES20.glUniformMatrix4fv(mvpMatrixHandle, 1, false, modelViewProjectionMatrix, 0);

    // Passar os vértices
    int positionHandle = GLES20.glGetAttribLocation(program, "aPosition");
    GLES20.glEnableVertexAttribArray(positionHandle);
    GLES20.glVertexAttribPointer(positionHandle, 3, GLES20.GL_FLOAT, false, 0, vertexBuffer);

    // Passar a cor (vermelho)
    int colorHandle = GLES20.glGetUniformLocation(program, "uColor");
    GLES20.glUniform4f(colorHandle, 1.0f, 0.0f, 0.0f, 1.0f);  // Cor vermelha

    // Desenhar o quadrado (dois triângulos)
    GLES20.glDrawElements(GLES20.GL_TRIANGLES, INDICES.length, GLES20.GL_UNSIGNED_SHORT, indexBuffer);

    // Desabilitar o atributo após o desenho
    GLES20.glDisableVertexAttribArray(positionHandle);
  }

  // Função para verificar se o shader foi compilado corretamente
  private static void checkShaderCompile(int shader) {
      int[] compileStatus = new int[1];
      GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, compileStatus, 0);
      if (compileStatus[0] == 0) {
          Log.e("ShaderError", GLES20.glGetShaderInfoLog(shader));
          GLES20.glDeleteShader(shader);
      }
  }

  // Função para verificar se o programa OpenGL foi linkado corretamente
  private static void checkProgramLink(int program) {
      int[] linkStatus = new int[1];
      GLES20.glGetProgramiv(program, GLES20.GL_LINK_STATUS, linkStatus, 0);
      if (linkStatus[0] == 0) {
          Log.e("ProgramError", GLES20.glGetProgramInfoLog(program));
      }
  }

}

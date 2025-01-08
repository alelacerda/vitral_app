package com.example.vitral_app;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public interface MyCallback<T> {
    public void onSuccess(T result);
    public void onFailure(@Nullable String error);
  }
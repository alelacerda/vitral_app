 package com.example.vitral_app

//  import androidx.compose.foundation.background
//  import androidx.compose.foundation.clickable
//  import androidx.compose.foundation.horizontalScroll
//  import androidx.compose.foundation.layout.*
//  import androidx.compose.foundation.rememberScrollState
//  import androidx.compose.foundation.shape.RoundedCornerShape
//  import androidx.compose.material3.Text
//  import androidx.compose.runtime.*
//  import androidx.compose.ui.Alignment
//  import androidx.compose.ui.Modifier
//  import androidx.compose.ui.graphics.Color
//  import androidx.compose.ui.text.font.FontWeight
//  import androidx.compose.ui.unit.dp
//  import androidx.compose.ui.unit.sp
//  import androidx.compose.ui.layout.onGloballyPositioned

//  // Category Enum
//  enum class Category(val title: String, val color: AppColor, val fadedColor: AppColor, val titleColor: AppColor) {
//      FUNFACTS("Curiosidades", AppColor.CUSTOM_ORANGE, AppColor.ORANGE_FADED, AppColor.WHITE),
//      PRODUCTION("Produção", AppColor.CUSTOM_PURPLE, AppColor.PURPLE_FADED, AppColor.WHITE),
//      CREDITS("Créditos", AppColor.CUSTOM_YELLOW, AppColor.YELLOW_FADED, AppColor.BLACK),
//      MEANING("Significados", AppColor.LILAC, AppColor.LILAC_FADED, AppColor.BLACK)
//  }

//  // CategorySelector Component
//  @Composable
//  fun CategorySelector(selectedCategory: Category?, onCategorySelected: (Category?) -> Unit) {
//      Row(
//          modifier = Modifier
//              .horizontalScroll(rememberScrollState())
//              .padding(16.dp)
//              .background(Color.White)
//      ) {
//          Category.values().forEach { category ->
//              CategoryButton(
//                  category = category,
//                  isSelected = category == selectedCategory,
//                  onTap = { onCategorySelected(category) }
//              )
//              Spacer(modifier = Modifier.width(16.dp))
//          }
//      }
//  }

//  // CategoryButton Component
// @Composable
//  fun CategoryButton(category: Category, isSelected: Boolean, onTap: () -> Unit) {
//      Column(
//          modifier = Modifier
//              .clickable(onClick = onTap)
//              .padding(8.dp),
//          horizontalAlignment = Alignment.CenterHorizontally
//      ) {
//          Text(
//              text = category.title.uppercase(),
//              fontSize = 18.sp,
//              color = Color.Black,
//          )
//          Spacer(modifier = Modifier.height(4.dp))
//          if (isSelected) {
//              Box(
//                  modifier = Modifier
//                      .height(4.dp)
//                      .width(40.dp)
//                      .background(category.color.color, shape = RoundedCornerShape(4.dp))
//              )
//          } else {
//              Spacer(modifier = Modifier.height(4.dp))
//          }
//      }
//  }

//  // Preview
//  @Composable
//  fun CategorySelectorPreview() {
//      var selectedCategory by remember { mutableStateOf<Category?>(Category.FUNFACTS) }
//      CategorySelector(selectedCategory = selectedCategory) { selectedCategory = it }
//  }

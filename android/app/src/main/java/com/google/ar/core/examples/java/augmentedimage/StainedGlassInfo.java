package com.example.vitral_app;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

public class StainedGlassInfo {
    private String title;
    private String description;
    private String category;
    private List<Double> position;
    private String imageUrl;
    private String articleId;

    public StainedGlassInfo(String title, String description, String category, List<Double> position, String imageUrl, String articleId) {
        this.title = title;
        this.description = description;
        this.category = category;
        this.position = position;
        this.imageUrl = imageUrl;
        this.articleId = articleId;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getCategory() {
        return category;
    }
    
    public String getCategoryText() {
        switch (category) {
            case "funfact":
                return "Curiosidades";
            case "production":
                return "Produção";
            case "credits":
                return "Créditos";
            case "meaning":
                return "Significado";
            default:
                return "";
        }
    }

    public String getCategoryColor() {
        switch (category) {
            case "funfact":
                return "#E04723";
            case "production":
                return "#480F5D";
            case "credits":
                return "#F89412";
            case "meaning":
                return "#9963AD";
            default:
                return "";
        }
    }

    public String getTextColorForCategory() {
        switch (category) {
            case "funfact":
                return "#FEFEFE";
            case "production":
                return "#FEFEFE";
            default:
                return "#010A10";
        }
    }

    public List<Double> getPosition() {
        return position;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getArticleId() {
        return articleId;
    }

    // Convert StainedGlassInfo to JSON (map)
    public Map<String, Object> toJson() {
        Map<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("description", description);
        map.put("category", category);
        map.put("position", position);
        map.put("imageUrl", imageUrl);
        map.put("articleId", articleId);
        return map;
    }

    // Create a StainedGlassInfo instance from a map
    public static StainedGlassInfo fromMap(Map<String, Object> map) {
        String title = (String) map.getOrDefault("title", "");
        String description = (String) map.getOrDefault("description", "");
        String category = (String) map.getOrDefault("category", "");
        List<Double> position = (List<Double>) map.getOrDefault("position", new ArrayList<>());
        String imageUrl = (String) map.get("image-url");
        String articleId = (String) map.get("article");

        return new StainedGlassInfo(title, description, category, position, imageUrl, articleId);
    }
}

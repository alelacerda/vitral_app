package com.example.vitral_app;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;


public class StainedGlass {
    private String title;
    private String locationId;
    private List<String> informationIds;

    public StainedGlass(String title, String locationId, List<String> informationIds) {
        this.title = title;
        this.locationId = locationId;
        this.informationIds = informationIds;
    }

    public String getTitle() {
        return title;
    }

    public String getLocationId() {
        return locationId;
    }

    public List<String> getInformationIds() {
        return informationIds;
    }

    // Convert StainedGlass to JSON (map)
    public Map<String, Object> toJson() {
        Map<String, Object> map = new HashMap<>();
        map.put("title", title);
        map.put("locationId", locationId);
        map.put("informationIds", informationIds);
        return map;
    }

    // Create a StainedGlass instance from a map
    public static StainedGlass fromMap(Map<String, Object> map) {
        String title = (String) map.get("title");
        String locationId = (String) map.get("location");
        List<String> informationIds = (List<String>) map.getOrDefault("info", new ArrayList<>());
        return new StainedGlass(title, locationId, informationIds);
    }
}

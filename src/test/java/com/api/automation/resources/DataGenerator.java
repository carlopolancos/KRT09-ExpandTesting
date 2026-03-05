package com.api.automation.resources;

import com.github.javafaker.Faker;

import net.minidev.json.JSONObject;

public class DataGenerator {

    static Faker faker = new Faker();
    String firstName = faker.name().firstName();
    String lastName = faker.name().lastName();
    int number1 = faker.number().numberBetween(1, 1000);
    int number2 = faker.number().numberBetween(1001, 2000);


    //methods have to be static to be called easier, fails many test due to static
    // public static String getRandomEmail() {
    //     return "test" + firstName.toLowerCase() + number + "@test.com";
    // }

    // public static String getRandomUsername() {
    //     return firstName.toLowerCase() + "." + lastName.toLowerCase();
    // }

    public String getRandomEmail() {
        return "test" + firstName.toLowerCase() + number1 + "@test.com";
    }

    public String getRandomUsername() {
        return firstName.toLowerCase() + "T" + lastName.toLowerCase();
    }

    public String getRandomPassword() {
        return number1 + firstName.toLowerCase() + number2 + "!?!#";
    }

    public static JSONObject getRandomArticleValues() {
        String title = faker.gameOfThrones().dragon();
        String description = faker.gameOfThrones().city();
        String body = faker.gameOfThrones().quote();
        JSONObject json = new JSONObject();
        json.put("title", title);
        json.put("description", description);
        json.put("body", body);
        return json;
    }
}

package com.example.budgettracker;

// Import Spring Boot application annotation
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// Marks this as the main Spring Boot application class
// Auto-scans components in com.example.budgettracker and sub-packages
@SpringBootApplication
public class BudgetTrackerBackendApplication {
    // Main method to start the application
    public static void main(String[] args) {
        SpringApplication.run(BudgetTrackerBackendApplication.class, args);
    }
}
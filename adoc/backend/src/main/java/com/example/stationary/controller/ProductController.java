package com.example.stationary.controller;

import com.example.stationary.model.Product;
import com.example.stationary.repository.ProductRepository;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@CrossOrigin(origins = "http://18.208.151.9:3000")  // Allow frontend access
@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductRepository productRepository;
    private static final Logger logger = LoggerFactory.getLogger(ProductController.class);

    public ProductController(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @GetMapping
    public List<Product> getAllProducts() {
        List<Product> products = productRepository.findAll();

        // Log fetched products in Java console
        logger.info("Fetched Products: {}", products);
        System.out.println("Fetched Products: " + products);

        return products;
    }
}

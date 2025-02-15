package com.example.stationary.repository;

import com.example.stationary.model.Product;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends MongoRepository<Product, String> {
    // No need for implementation, Spring Data MongoDB does it automatically
}

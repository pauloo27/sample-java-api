package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.HealthDto;
import com.example.demo.dto.HealthStatus;

@RestController()
public class HealthController {

  @GetMapping("/health")
  public HealthDto getHealthStatus() {
    return new HealthDto(HealthStatus.UP);
  }
}

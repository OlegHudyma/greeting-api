package com.epam.training.greeting.controller;

import com.epam.training.greeting.api.GreetingApi;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController implements GreetingApi {

  @Override
  public String greet(String name) {
    return "Hello ".concat(name);
  }
}

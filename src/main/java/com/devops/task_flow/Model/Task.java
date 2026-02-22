package com.devops.task_flow.Model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Task {

    private Long id;

    @NotBlank(message = "title is required")
    private String title;
    private boolean completed;

}

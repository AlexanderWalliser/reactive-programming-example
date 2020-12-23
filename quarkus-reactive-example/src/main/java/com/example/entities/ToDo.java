package com.example.entities;

import javax.persistence.*;
import javax.persistence.GeneratedValue;

@Entity
public class ToDo {
    @Id @GeneratedValue
    private Integer id;

    private String text;

    public ToDo() {
    }

    public ToDo(String text) {
        this.text = text;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }


    @Override
    public String toString() {
        return "ToDo{" +
                "id=" + id +
                ", text='" + text + '\'' +
                '}';
    }
}

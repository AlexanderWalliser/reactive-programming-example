package com.example.entities;

public class ToDoEvent {
    private ChangeTyp changeTyp;
    private Integer id;
    private String Text;

    public ToDoEvent() {
    }

    public ToDoEvent(ChangeTyp changeTyp, Integer id, String text) {
        this.changeTyp = changeTyp;
        this.id = id;
        Text = text;
    }

    public ChangeTyp getChangeTyp() {
        return changeTyp;
    }

    public void setChangeTyp(ChangeTyp changeTyp) {
        this.changeTyp = changeTyp;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getText() {
        return Text;
    }

    public void setText(String text) {
        Text = text;
    }

    @Override
    public String toString() {
        return "ToDoEvent{" +
                "changeTyp=" + changeTyp +
                ", id=" + id +
                ", Text='" + Text + '\'' +
                '}';
    }
}

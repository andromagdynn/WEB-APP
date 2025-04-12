package com.progetto.ecomcaffe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

// ORM - Object Relational Model

@Getter // non ho bisogno di mettere get/set
@Setter
@Entity
@Table(name="brand")
public class Brand {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "nome", nullable = false, unique = true)
    private String nome;

}

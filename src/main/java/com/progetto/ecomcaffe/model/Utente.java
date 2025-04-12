package com.progetto.ecomcaffe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="utenti")
public class Utente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "username", nullable = false, unique = true)
    private String username;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "ruolo", nullable = false)
    private Ruolo ruolo;

    @Enumerated(EnumType.STRING)
    @Column(name = "stato", nullable = false)
    private Stato stato;

    public enum Ruolo {
        PUBBLICO, REGISTRATO, ADMIN
    }

    public enum Stato {
        ATTIVO, BLOCCATO
    }
}

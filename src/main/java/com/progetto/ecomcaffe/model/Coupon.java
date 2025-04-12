package com.progetto.ecomcaffe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.sql.Date;

@Getter
@Setter
@Entity
@Table(name="coupon")
public class Coupon {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "codice", nullable = false, unique = true)
    private String codice;

    @Column(name = "sconto", nullable = false)
    private BigDecimal sconto;

    @Column(name = "data_scadenza", nullable = false)
    private Date dataScadenza;

    @Column(name = "usato", nullable = false)
    private Boolean usato;

    @ManyToOne
    @JoinColumn(name = "utente_id", nullable = true)
    private Utente utente;
}

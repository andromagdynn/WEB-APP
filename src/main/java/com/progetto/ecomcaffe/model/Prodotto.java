package com.progetto.ecomcaffe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@Entity
@Table(name="prodotti")
public class Prodotto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "nome", nullable = false)
    private String nome;

    @Column(name = "descrizione", length = 1000)
    private String descrizione;

    @Column(name = "prezzo", nullable = false)
    private BigDecimal prezzo;

    @Column(name = "disponibilita", nullable = false)
    private Integer disponibilita;

    @ManyToOne
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;

    @ManyToOne
    @JoinColumn(name = "brand_id")
    private Brand brand;

    @Column(name = "in_vetrina", nullable = false)
    private Boolean inVetrina;

    @Column(name = "immagine", nullable = false)
    private String immagine;

    @Column(name = "visualizzazioni", nullable = false)
    private Long visualizzazioni = 0L;
}

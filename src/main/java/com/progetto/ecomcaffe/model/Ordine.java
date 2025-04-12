package com.progetto.ecomcaffe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name="ordini")
public class Ordine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "utente_id", nullable = false)
    private Utente utente;

    @Column(name = "totale", nullable = false)
    private BigDecimal totale;

    @Enumerated(EnumType.STRING)
    @Column(name = "stato", nullable = false)
    private StatoOrdine stato = StatoOrdine.IN_ATTESA;

    @Column(name = "indirizzo", nullable = false)
    private String indirizzo;

    @Column(name = "data_ordine", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date dataOrdine;

    public enum StatoOrdine {
        IN_ATTESA, SPEDITO, CONSEGNATO, ANNULLATO
    }
}

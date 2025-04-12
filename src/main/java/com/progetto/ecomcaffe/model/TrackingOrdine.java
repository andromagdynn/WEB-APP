package com.progetto.ecomcaffe.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@Entity
@Table(name = "tracking_ordini")
public class TrackingOrdine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "ordine_id", nullable = false)
    private Ordine ordine;

    @Enumerated(EnumType.STRING)
    @Column(name = "stato", nullable = false)
    private StatoTracking stato;

    @Column(name = "data", nullable = false)
    private Timestamp data;

    public enum StatoTracking {
        PRESO_IN_CARICO, IN_TRANSITO, IN_CONSEGNA, CONSEGNATO
    }
}

package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.Prodotto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProdottoRepository extends JpaRepository<Prodotto, Integer> {

    // Filtra i prodotti per categoria, brand e testo di ricerca.
    @Query("SELECT p FROM Prodotto p " +
            "WHERE (:categoria IS NULL OR p.categoria.nome = :categoria) " +
            "AND (:brand IS NULL OR p.brand.nome = :brand) " +
            "AND (:ricerca IS NULL OR LOWER(p.nome) LIKE LOWER(CONCAT('%', :ricerca, '%')))")
    List<Prodotto> filtraProdotti(
            @Param("categoria") String categoria,
            @Param("brand") String brand,
            @Param("ricerca") String ricerca
    );

    // Recupera i prodotti in vetrina.
    @Query("SELECT p FROM Prodotto p WHERE p.inVetrina = true")
    List<Prodotto> findByInVetrinaTrue();

    // Ordina i prodotti per visualizzazioni in ordine decrescente.
    @Query("SELECT p FROM Prodotto p ORDER BY p.visualizzazioni DESC")
    List<Prodotto> findProdottiPiuVisti();

    // Incrementa le visualizzazioni di un prodotto.
    @Transactional
    @Modifying
    @Query("UPDATE Prodotto p SET p.visualizzazioni = p.visualizzazioni + 1 WHERE p.id = :prodottoId")
    void incrementaVisualizzazioni(@Param("prodottoId") Integer prodottoId);

    // Recupera un prodotto per ID.
    @Query("SELECT p FROM Prodotto p WHERE p.id = :id")
    Optional<Prodotto> findById(@Param("id") Integer id);
}
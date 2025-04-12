package com.progetto.ecomcaffe.repository;

import com.progetto.ecomcaffe.model.Coupon;
import com.progetto.ecomcaffe.model.Utente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CouponRepository extends JpaRepository<Coupon, Integer> {
    Optional<Coupon> findByCodice(String codice);
}

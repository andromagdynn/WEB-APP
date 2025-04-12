package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Coupon;
import com.progetto.ecomcaffe.model.Utente;
import com.progetto.ecomcaffe.repository.CouponRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Optional;

@Service
public class CouponService {

    private final CouponRepository couponRepository;

    @Autowired
    public CouponService(CouponRepository couponRepository) {
        this.couponRepository = couponRepository;
    }

    // Restituisce il coupon tramite codice, oppure null se non trovato.
    public Coupon getCouponByCode(String codice) {
        return couponRepository.findByCodice(codice).orElse(null);
    }

    // Restituisce un Optional contenente il coupon per ID.
    public Optional<Coupon> getCouponById(Integer id) {
        return couponRepository.findById(id);
    }

    // Verifica se il coupon è valido (non usato e non scaduto).
    public boolean isCouponValid(Coupon coupon) {
        if (coupon == null || coupon.getUsato()) {
            return false;
        }
        Date oggi = new Date(System.currentTimeMillis());
        return coupon.getDataScadenza().after(oggi) || coupon.getDataScadenza().equals(oggi);
    }

    // Applica il coupon all'utente.
    public void applyCoupon(Coupon coupon, Utente utente) {
        coupon.setUsato(true);
        coupon.setUtente(utente);
        couponRepository.save(coupon);
    }

    // Calcola il totale scontato e restituisce il valore arrotondato a 2 decimali.
    public BigDecimal calcolaSconto(BigDecimal totale, Coupon coupon) {
        if (coupon == null || !isCouponValid(coupon)) {
            return totale.setScale(2, BigDecimal.ROUND_HALF_UP);
        }
        BigDecimal percentuale = coupon.getSconto().divide(new BigDecimal(100));
        BigDecimal totaleScontato = totale.subtract(totale.multiply(percentuale));
        return totaleScontato.setScale(2, BigDecimal.ROUND_HALF_UP);
    }

    // Rimuove il coupon, disassocciandolo dall'utente e reimpostando lo stato.
    public void rimuoviCoupon(Coupon coupon) {
        coupon.setUtente(null);
        coupon.setUsato(false);
        couponRepository.save(coupon);
    }

    // Crea un nuovo coupon.
    public Coupon createCoupon(Coupon coupon) {
        return couponRepository.save(coupon);
    }

    // Restituisce tutti i coupon.
    public List<Coupon> getAllCoupons() {
        return couponRepository.findAll();
    }
}
package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Brand;
import com.progetto.ecomcaffe.repository.BrandRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BrandService {

    // Repository per l'accesso ai dati dei brand.
    private final BrandRepository brandRepository;

    @Autowired
    public BrandService(BrandRepository brandRepository) {
        this.brandRepository = brandRepository;
    }

    // Recupera tutti i brand.
    public List<Brand> getAllBrands() {
        return brandRepository.findAll();
    }

    // Crea un nuovo brand.
    public Brand createBrand(Brand brand) {
        return brandRepository.save(brand);
    }

    // Aggiorna un brand esistente.
    public Brand updateBrand(Brand brand) {
        return brandRepository.save(brand);
    }

    // Elimina un brand per ID.
    public void deleteBrand(int id) {
        brandRepository.deleteById(id);
    }
}

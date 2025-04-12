package com.progetto.ecomcaffe.service;

import com.progetto.ecomcaffe.model.Categoria;
import com.progetto.ecomcaffe.repository.CategoriaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaRepository categoriaRepository;

    @Autowired
    public CategoriaService(CategoriaRepository categoriaRepository) {
        this.categoriaRepository = categoriaRepository;
    }

    // Recupera tutte le categorie.
    public List<Categoria> getAllCategorie() {
        return categoriaRepository.findAll();
    }

    // Crea una nuova categoria.
    public Categoria createCategoria(Categoria categoria) {
        return categoriaRepository.save(categoria);
    }

    // Aggiorna una categoria esistente.
    public Categoria updateCategoria(Categoria categoria) {
        return categoriaRepository.save(categoria);
    }

    // Elimina una categoria per ID.
    public void deleteCategoria(int id) {
        categoriaRepository.deleteById(id);
    }
}
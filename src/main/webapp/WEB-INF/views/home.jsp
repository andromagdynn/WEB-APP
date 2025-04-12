<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Home - EcomCaffe</title>
  <!-- Bootstrap 5 CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    body {
      background-color: #f8f9fa;
    }
    /* Navbar unificata */
    .navbar { background-color: #343a40; }
    .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
    /* Mantenimento dei link in bianco nella navbar, mentre nel dropdown usiamo colori di default */
    .nav-link { color: white !important; }
    .dropdown-menu { background-color: white; }
    .dropdown-item { color: #343a40; }
    /* Stile dei product card */
    .product-card {
      transition: transform 0.3s;
      cursor: pointer;
    }
    .product-card:hover {
      transform: scale(1.05);
    }
    /* Stili per la modale */
    .modal-header, .modal-body, .modal-footer { text-align: center; }
    .modal-title { font-size: 1.5rem; font-weight: bold; }
  </style>
</head>
<body>
<!-- Navbar con icona del carrello e dropdown account -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="#">EcomCaffe</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
      <ul class="navbar-nav me-3">
        <!-- Icona del carrello -->
        <li class="nav-item">
          <a class="nav-link" href="/carrello">
            <i class="bi bi-cart"></i>
          </a>
        </li>
      </ul>
      <ul class="navbar-nav">
        <c:choose>
          <c:when test="${not empty sessionScope.utente}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                  ${sessionScope.utente.username}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="/profilo">Profilo</a></li>
                <li><a class="dropdown-item" href="/wishlist">Wishlist</a></li>
                <li><a class="dropdown-item" href="/carrello/storico">Storico</a></li>
                <c:if test="${sessionScope.utente.ruolo eq 'ADMIN'}">
                  <li><a class="dropdown-item" href="/admin">Admin</a></li>
                </c:if>
                <li><a class="dropdown-item" href="/logout">Logout</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="guestDropdown" role="button" data-bs-toggle="dropdown">
                Account
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="guestDropdown">
                <li><a class="dropdown-item" href="/login">Login</a></li>
                <li><a class="dropdown-item" href="/registrati">Registrati</a></li>
              </ul>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
  <!-- Sezione Filtro -->
  <div class="row mb-4">
    <div class="col-md-4">
      <form action="/" method="get" class="input-group">
        <input type="text" name="ricerca" class="form-control" placeholder="Cerca un prodotto..." value="${param.ricerca}">
        <button class="btn btn-dark" type="submit">Cerca</button>
      </form>
    </div>
    <div class="col-md-4">
      <form action="/" method="get">
        <select name="categoria" class="form-select" onchange="this.form.action += '#catalogo'; this.form.submit()">
          <option value="">Seleziona Categoria</option>
          <c:forEach var="cat" items="${categorie}">
            <option value="${cat.nome}" <c:if test="${param.categoria eq cat.nome}">selected</c:if>>${cat.nome}</option>
          </c:forEach>
        </select>
      </form>
    </div>
    <div class="col-md-4">
      <form action="/" method="get">
        <select name="brand" class="form-select" onchange="this.form.action += '#catalogo'; this.form.submit()">
          <option value="">Seleziona Brand</option>
          <c:forEach var="b" items="${brand}">
            <option value="${b.nome}" <c:if test="${param.brand eq b.nome}">selected</c:if>>${b.nome}</option>
          </c:forEach>
        </select>
      </form>
    </div>
  </div>

  <!-- Catalogo Prodotti -->
  <h3 id="catalogo">📦 Catalogo Prodotti</h3>
  <div class="row">
    <c:forEach var="prodotto" items="${prodotti}">
      <!-- Mostra solo se disponibilità > 0 -->
      <c:if test="${prodotto.disponibilita > 0}">
        <div class="col-md-3 mb-4">
          <div class="card product-card"
               data-id="${prodotto.id}"
               data-nome="${prodotto.nome}"
               data-descrizione="${prodotto.descrizione}"
               data-immagine="${prodotto.immagine}"
               data-prezzo="${prodotto.prezzo}"
               data-disponibilita="${prodotto.disponibilita}">
            <img src="${prodotto.immagine}" class="card-img-top" alt="${prodotto.nome}">
            <div class="card-body text-center">
              <h5 class="card-title">${prodotto.nome}</h5>
              <p class="card-text">${prodotto.prezzo}€</p>
            </div>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </div>

  <!-- Prodotti Più Visualizzati -->
  <h3 class="mt-4">📊 I Più Visualizzati</h3>
  <div class="row">
    <c:forEach var="prodotto" items="${prodottiPiuVisti}">
      <c:if test="${prodotto.disponibilita > 0}">
        <div class="col-md-3 mb-4">
          <div class="card product-card"
               data-id="${prodotto.id}"
               data-nome="${prodotto.nome}"
               data-descrizione="${prodotto.descrizione}"
               data-immagine="${prodotto.immagine}"
               data-prezzo="${prodotto.prezzo}"
               data-disponibilita="${prodotto.disponibilita}">
            <img src="${prodotto.immagine}" class="card-img-top" alt="${prodotto.nome}">
            <div class="card-body text-center">
              <h5 class="card-title">${prodotto.nome}</h5>
              <p class="card-text">${prodotto.prezzo}€  |  👀 ${prodotto.visualizzazioni} visualizzazioni</p>
            </div>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </div>

  <!-- Prodotti in Vetrina -->
  <h3 class="mt-4">🔥 Prodotti in Vetrina</h3>
  <div class="row">
    <c:forEach var="prodotto" items="${prodottiVetrina}">
      <c:if test="${prodotto.disponibilita > 0}">
        <div class="col-md-3 mb-4">
          <div class="card product-card"
               data-id="${prodotto.id}"
               data-nome="${prodotto.nome}"
               data-descrizione="${prodotto.descrizione}"
               data-immagine="${prodotto.immagine}"
               data-prezzo="${prodotto.prezzo}"
               data-disponibilita="${prodotto.disponibilita}">
            <img src="${prodotto.immagine}" class="card-img-top" alt="${prodotto.nome}">
            <div class="card-body text-center">
              <h5 class="card-title">${prodotto.nome}</h5>
              <p class="card-text">${prodotto.prezzo}€</p>
            </div>
          </div>
        </div>
      </c:if>
    </c:forEach>
  </div>
</div>

<!-- Modale per il dettaglio prodotto -->
<div class="modal fade" id="productModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 id="modalNome" class="modal-title"></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <img id="modalImmagine" src="" alt="" class="img-fluid mb-3">
        <p id="modalDescrizione"></p>
        <p id="modalPrezzo" class="fw-bold"></p>
        <!-- Opzioni per utenti registrati/admin -->
        <c:if test="${not empty sessionScope.utente}">
          <div class="mt-3">
            <form id="formCarrello" method="post">
              <div class="input-group mb-2">
                <span class="input-group-text">Quantità</span>
                <!-- Aggiungiamo un id per impostare dinamicamente il max -->
                <input type="number" name="quantita" id="quantityInput" value="1" min="1" class="form-control">
              </div>
              <button type="submit" class="btn btn-primary w-100 mb-2">Aggiungi al Carrello</button>
            </form>
            <form id="formWishlist" method="post">
              <input type="hidden" name="quantita" value="1">
              <button type="submit" class="btn btn-secondary w-100">Aggiungi alla Wishlist</button>
            </form>
          </div>
        </c:if>
      </div>
    </div>
  </div>
</div>

<!-- Script per gestire l'aggiornamento della modale e l'invio della richiesta di visualizzazione -->
<script>
  // Variabile per verificare se l'utente è loggato
  var userLogged = false;
  <c:if test="${not empty sessionScope.utente}">
  userLogged = true;
  </c:if>

  document.addEventListener("DOMContentLoaded", function() {
    var cards = document.querySelectorAll(".product-card");
    cards.forEach(function(card) {
      card.addEventListener("click", function() {
        var id = card.getAttribute("data-id");
        var nome = card.getAttribute("data-nome");
        var descrizione = card.getAttribute("data-descrizione");
        var immagine = card.getAttribute("data-immagine");
        var prezzo = card.getAttribute("data-prezzo");
        // Recuperiamo la disponibilità
        var disponibilita = card.getAttribute("data-disponibilita");

        openProductModal(id, nome, descrizione, immagine, prezzo, disponibilita);
      });
    });
  });

  function openProductModal(id, nome, descrizione, immagine, prezzo, disponibilita) {
    document.getElementById("modalNome").innerText = nome;
    document.getElementById("modalDescrizione").innerText = descrizione;
    document.getElementById("modalImmagine").src = immagine;
    document.getElementById("modalPrezzo").innerText = "Prezzo: " + prezzo + "€";

    if (userLogged) {
      document.getElementById("formCarrello").action = "/carrello/aggiungi/" + id;
      document.getElementById("formWishlist").action = "/wishlist/aggiungi/" + id;

      // Imposta il valore max in base alla disponibilità
      var quantityInput = document.getElementById("quantityInput");
      quantityInput.setAttribute("max", disponibilita);
      // Se la quantità selezionata è maggiore della disponibilità, la resettiamo
      if (parseInt(quantityInput.value) > parseInt(disponibilita)) {
        quantityInput.value = disponibilita;
      }
    }

    // Invia la richiesta per incrementare le visualizzazioni
    fetch('/api/prodotto/' + id + '/incrementaVisualizzazioni', {
      method: 'POST'
    })
            .then(function(response) {
              if (!response.ok) {
                console.error("Errore nell'incremento delle visualizzazioni per il prodotto con id " + id);
              }
            })
            .catch(function(error) {
              console.error("Errore nella richiesta di incremento visualizzazioni: ", error);
            });

    var modal = new bootstrap.Modal(document.getElementById("productModal"));
    modal.show();
  }
</script>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
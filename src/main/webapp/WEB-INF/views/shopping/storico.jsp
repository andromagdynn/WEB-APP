<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <title>Storico Ordini - EcomCaffe</title>
  <!-- Importazione di Bootstrap per lo styling della pagina -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Importazione di jQuery per le chiamate AJAX -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <!-- Importazione opzionale delle icone Bootstrap -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
  <style>
    /* Impostazioni di base per il background e la navbar */
    body {
      background-color: #f8f9fa;
    }
    .navbar {
      background-color: #343a40;
    }
    .navbar-brand {
      color: white !important;
      font-size: 1.8rem;
      font-weight: bold;
    }
    .nav-link {
      color: white !important;
    }
    .dropdown-menu {
      background-color: white;
    }
    .dropdown-item {
      color: #343a40;
    }
  </style>
</head>
<body>

<!-- Header: Barra di navigazione principale -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <!-- Logo e link alla home -->
    <a class="navbar-brand" href="/">EcomCaffe</a>
    <!-- Pulsante per la visualizzazione del menu su dispositivi mobili -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <!-- Menu di navigazione -->
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
        <!-- Visualizzazione del menu in base all'autenticazione dell'utente -->
        <c:choose>
          <c:when test="${not empty sessionScope.utente}">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="/" id="userDropdown" role="button" data-bs-toggle="dropdown">
                  ${sessionScope.utente.username}
              </a>
              <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                <li><a class="dropdown-item" href="/profilo">Profilo</a></li>
                <li><a class="dropdown-item" href="/wishlist">Wishlist</a></li>
                <c:if test="${sessionScope.utente.ruolo eq 'ADMIN'}">
                  <li><a class="dropdown-item" href="/admin">Admin</a></li>
                </c:if>
                <li><a class="dropdown-item" href="/logout">Logout</a></li>
              </ul>
            </li>
          </c:when>
          <c:otherwise>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="/" id="guestDropdown" role="button" data-bs-toggle="dropdown">
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

<!-- Corpo della pagina: Visualizzazione dello storico ordini -->
<div class="container mt-4">
  <h3>Storico Ordini</h3>

  <!-- Se non sono presenti ordini, mostra un messaggio informativo -->
  <c:if test="${empty ordini}">
    <div class="alert alert-info">Non hai ancora effettuato ordini.</div>
  </c:if>

  <!-- Ciclo per mostrare ciascun ordine -->
  <c:forEach var="ordine" items="${ordini}">
    <div class="card mb-3">
      <div class="card-body">
        <!-- Dettagli principali dell'ordine -->
        <h5 class="card-title">Ordine #${ordine.id}</h5>
        <p class="card-text">
          Totale: <strong>${ordine.totale}€</strong><br>
          Indirizzo: ${ordine.indirizzo}<br>
          Stato: <span class="badge bg-info">${ordine.stato}</span><br>
          Data: ${ordine.dataOrdine}
        </p>
        <!-- Pulsante per visualizzare i dettagli dell'ordine -->
        <button class="btn btn-primary btn-sm view-details" data-ordine-id="${ordine.id}">Visualizza Dettagli</button>
      </div>

      <!-- Sezione nascosta per i dettagli dell'ordine, da mostrare al click -->
      <div id="dettagli-ordine-${ordine.id}" class="dettagli-ordine mt-3" style="display:none;">
        <div class="card">
          <div class="card-body">
            <h6>Dettagli Ordine #${ordine.id}</h6>
            <table class="table">
              <thead>
              <tr>
                <th>Prodotto</th>
                <th>Quantità</th>
                <th>Prezzo Unitario</th>
                <th>Subtotale</th>
              </tr>
              </thead>
              <tbody id="ordine-dettagli-body-${ordine.id}">
              <!-- I dettagli verranno caricati dinamicamente via AJAX -->
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </c:forEach>
</div>

<!-- Script per la gestione della visualizzazione dei dettagli degli ordini -->
<script>
  $(document).ready(function() {
    // Gestione del click sul pulsante "Visualizza Dettagli"
    $(".view-details").click(function() {
      let ordineId = $(this).data("ordine-id");
      let dettagliDiv = $("#dettagli-ordine-" + ordineId);
      let tbody = $("#ordine-dettagli-body-" + ordineId);
      // Se i dettagli sono già visibili, nascondili; altrimenti, carica i dati via AJAX
      if (dettagliDiv.is(":visible")) {
        dettagliDiv.hide();
      } else {
        $.get("/carrello/ordine/dettagli/" + ordineId, function(data) {
          tbody.empty();
          if (data.length === 0) {
            tbody.append("<tr><td colspan='4'>Nessun prodotto trovato.</td></tr>");
          } else {
            // Ciclo per inserire ogni dettaglio dell'ordine nella tabella
            data.forEach(function(item) {
              tbody.append(
                      "<tr>" +
                      "<td>" + item.prodottoNome + "</td>" +
                      "<td>" + item.quantita + "</td>" +
                      "<td>" + item.prezzo.toFixed(2) + "€</td>" +
                      "<td>" + item.subtotale.toFixed(2) + "€</td>" +
                      "</tr>"
              );
            });
          }
          dettagliDiv.show();
        });
      }
    });
  });
</script>

<!-- Inclusione degli script JS di Bootstrap per il corretto funzionamento della pagina -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
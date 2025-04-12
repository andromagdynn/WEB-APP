<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="it">
<head>
  <!-- Meta e titolazione della pagina -->
  <meta charset="UTF-8">
  <title>Gestione Utenti - EcomCaffe</title>

  <!-- Inclusione dei file CSS di Bootstrap e Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

  <!-- Definizione degli stili personalizzati per la pagina -->
  <style>
    body {
      background-color: #f8f9fa;
    }
    /* Stile della navbar per il pannello admin */
    .navbar { background-color: #343a40; }
    .navbar-brand { color: white !important; font-size: 1.8rem; font-weight: bold; }
    .nav-link { color: white !important; }
    .dropdown-menu { background-color: white; }
    .dropdown-item { color: #343a40; }
    /* Stile per la modale: centratura del testo */
    .modal-header, .modal-body, .modal-footer { text-align: center; }
    .modal-title { font-size: 1.5rem; font-weight: bold; }
  </style>

  <!-- Inclusione di jQuery per le operazioni Ajax -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
<!-- Navbar principale per la gestione utenti -->
<nav class="navbar navbar-expand-lg navbar-dark">
  <div class="container">
    <a class="navbar-brand" href="/admin">EcomCaffe - Pannello Admin</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
  </div>
</nav>

<!-- Sezione principale: tabella di gestione degli utenti -->
<div class="container mt-5">
  <h1 class="mb-4">Gestione Utenti</h1>
  <table class="table table-striped">
    <thead>
    <tr>
      <th>ID</th>
      <th>Username</th>
      <th>Email</th>
      <th>Ruolo</th>
      <th>Stato</th>
      <th>Numero Ordini</th>
      <th>Azioni</th>
    </tr>
    </thead>
    <tbody>
    <!-- Ciclo per visualizzare ogni utente -->
    <c:forEach var="utente" items="${utenti}">
      <tr>
        <td>${utente.id}</td>
        <td>${utente.username}</td>
        <td>${utente.email}</td>
        <td>${utente.ruolo}</td>
        <td>${utente.stato}</td>
        <td>${ordiniCount[utente.id]}</td>
        <td>
          <!-- Gruppo di pulsanti per le azioni amministrative sull'utente -->
          <div class="btn-group" role="group">
            <button class="btn btn-warning btn-sm" onclick="toggleRole(${utente.id}, '${utente.ruolo}')">Cambia Ruolo</button>
            <button class="btn btn-primary btn-sm" onclick="showOrders(${utente.id})">Ordini</button>
          </div>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>
</div>

<!-- Modal per la visualizzazione degli ordini di un utente -->
<div class="modal fade" id="ordersModal" tabindex="-1" aria-labelledby="ordersModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="ordersModalLabel">Ordini Utente</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Chiudi"></button>
      </div>
      <div class="modal-body">
        <ul id="ordersList" class="list-group"></ul>
      </div>
    </div>
  </div>
</div>

<!-- Modal per la visualizzazione dei dettagli di un ordine -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1" aria-labelledby="orderDetailsModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="orderDetailsModalLabel">Dettagli Ordine</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Chiudi"></button>
      </div>
      <div class="modal-body">
        <ul id="orderDetailsList" class="list-group"></ul>
      </div>
    </div>
  </div>
</div>

<!-- Modal per la visualizzazione di messaggi informativi -->
<div class="modal fade" id="messageModal" tabindex="-1" aria-labelledby="messageModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="messageModalLabel">Messaggio</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Chiudi"></button>
      </div>
      <div class="modal-body">
        <p id="messageContent"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Chiudi</button>
      </div>
    </div>
  </div>
</div>

<!-- Impostazione dell'ID dell'utente corrente dalla sessione, se disponibile -->
<c:if test="${not empty sessionScope.user}">
  <c:set var="currentUserId" value="${sessionScope.user.id}" />
</c:if>

<script>
  // Imposta currentUserId a 0 se non definito per evitare errori JavaScript
  var currentUserId = <c:out value="${currentUserId != null ? currentUserId : 0}" />;

  // Funzione per mostrare un messaggio in un modal
  function showMessage(message) {
    $('#messageContent').text(message);
    $('#messageModal').modal('show');
  }

  // Funzione per cambiare il ruolo di un utente (non si può modificare il proprio ruolo)
  function toggleRole(userId, currentRole) {
    if (userId == currentUserId) {
      showMessage("Non puoi cambiare il tuo ruolo.");
      return;
    }
    $.post("/admin/utente/toggleRole", { utenteId: userId }, function(response) {
      showMessage(response);
      setTimeout(function() { location.reload(); }, 2000);
    });
  }

  // Funzione per richiedere e visualizzare gli ordini di un utente
  function showOrders(userId) {
    $.get("/admin/utente/" + userId + "/ordini", function(ordini) {
      var ordersList = $('#ordersList');
      ordersList.empty();
      if (ordini.length === 0) {
        ordersList.append('<li class="list-group-item">Non ci sono ordini.</li>');
      } else {
        ordini.forEach(function(ordine) {
          ordersList.append(
                  '<li class="list-group-item">' +
                  '<a href="#" onclick="getOrderDetails(' + ordine.id + '); return false;">ID Ordine: ' + ordine.id + '</a>' +
                  ' - Totale: ' + ordine.totale + '€ - Stato: ' + ordine.stato +
                  '<select onchange="changeOrderStatus(' + ordine.id + ', this.value)">' +
                  '<option value="IN_ATTESA"' + (ordine.stato === 'IN_ATTESA' ? ' selected' : '') + '>In Attesa</option>' +
                  '<option value="SPEDITO"' + (ordine.stato === 'SPEDITO' ? ' selected' : '') + '>Spedito</option>' +
                  '<option value="CONSEGNATO"' + (ordine.stato === 'CONSEGNATO' ? ' selected' : '') + '>Consegnato</option>' +
                  '<option value="ANNULLATO"' + (ordine.stato === 'ANNULLATO' ? ' selected' : '') + '>Annullato</option>' +
                  '</select>' +
                  '</li>'
          );
        });
      }
      $('#ordersModal').modal('show');
    });
  }

  // Funzione per aggiornare lo stato di un ordine tramite richiesta AJAX
  function changeOrderStatus(ordineId, newStatus) {
    $.post("/admin/ordine/updateStatus", { ordineId: ordineId, statoSpedizione: newStatus }, function(response) {
      showMessage("Stato aggiornato: " + response);
    });
  }

  // Funzione per ottenere i dettagli degli articoli di un ordine e mostrarli in un modal
  function getOrderDetails(ordineId) {
    $.get("/admin/ordine/dettagli/" + ordineId, function(dettagli) {
      var detailsList = $('#orderDetailsList');
      detailsList.empty();
      if (dettagli.length === 0) {
        detailsList.append('<li class="list-group-item">Nessun dettaglio trovato per questo ordine.</li>');
      } else {
        dettagli.forEach(function(det) {
          detailsList.append(
                  '<li class="list-group-item">' +
                  'Prodotto: ' + det.prodottoNome +
                  ' - Quantità: ' + det.quantita +
                  ' - Prezzo: ' + det.prezzo + '€' +
                  ' - Subtotale: ' + det.subtotale + '€' +
                  '</li>'
          );
        });
      }
      $('#orderDetailsModal').modal('show');
    });
  }
</script>

<!-- Inclusione degli script JS di Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
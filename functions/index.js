const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Configuración del correo desde Firebase CLI
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

exports.enviarPedido = functions.https.onCall(async (data, context) => {
  const { nombre, correo, pedidosGorras, pedidosPantalones, pedidosTelas } = data;

  const buildTable = (title, pedidos) => {
    if (!pedidos.length) return '';
    let html = `<h3>${title}</h3><table border="1" cellspacing="0" cellpadding="4"><tr>`;
    Object.keys(pedidos[0]).forEach((key) => {
      html += `<th>${key}</th>`;
    });
    html += `</tr>`;
    pedidos.forEach(pedido => {
      html += `<tr>`;
      Object.values(pedido).forEach((value) => {
        html += `<td>${value}</td>`;
      });
      html += `</tr>`;
    });
    html += `</table><br>`;
    return html;
  };

  const htmlContent = `
    <h2>PEDIDO de ${nombre}</h2>
    <p><strong>Correo:</strong> ${correo}</p>
    ${buildTable('Pedidos de Gorras', pedidosGorras)}
    ${buildTable('Pedidos de Pantalones', pedidosPantalones)}
    ${buildTable('Pedidos de Telas', pedidosTelas)}
  `;

  const mailOptions = {
    from: gmailEmail,
    to: gmailEmail,
    subject: `PEDIDO de ${nombre}`,
    html: htmlContent,
  };

  try {
    await transporter.sendMail(mailOptions);
    return { success: true };
  } catch (error) {
    console.error('Error enviando el correo:', error);
    throw new functions.https.HttpsError('internal', 'No se pudo enviar el correo');
  }
});

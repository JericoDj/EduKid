const functions = require("firebase-functions");
const axios = require("axios");

// Example function to handle payment processing
exports.processPayment = functions.https.onRequest(async (req, res) => {
  const { nonce, amount } = req.body;

  try {
    const response = await axios.post(
      "https://connect.squareupsandbox.com/v2/payments", // Updated to sandbox URL
      {
        source_id: nonce,
        amount_money: {
          amount: amount,
          currency: "USD",
        },
      },
      {
        headers: {
          "Authorization": "Bearer EAAAl3xPPZ-EQukdMTUZjnGlrPTN9rnLWeJRGJNaBCzenFSj7QmlGW4hNdR9HSvn", // Ensure this is the sandbox access token
          "Content-Type": "application/json",
        },
      }
    );

    res.status(200).send(response.data);
  } catch (error) {
    console.error("Payment processing error:", error);
    res.status(500).send(
      error.response ? error.response.data : { error: "Internal Server Error" }
    );
  }
});

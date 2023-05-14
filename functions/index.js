/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const functions = require("firebase-functions");
const logger = require("firebase-functions/logger");
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
    try {
        let customerId;
        //Gets the customer who's email id matches the one sent by the client
        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });

        //Checks the if the customer exists, if not creates a new customer
        if (customerList.data.length != 0) {
            customerId = customerList.data[0].id;
        }
        else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.data.id;
        }

        //Creates a temporary secret key linked with the customer 
        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2022-11-15' }
        );

        //Creates a new payment intent with amount passed in from the client
        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseFloat(req.body.amount) * 100,
            currency: 'myr',
            customer: customerId,
        })

        //Sends the client the payment intent secret, ephemeral key secret and customer id
        res.status(200).send({
            success: true,
            paymentIntentId: paymentIntent.id,
            clientSecret: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
        })

    } catch (error) {
        res.status(404).send({ success: false, error: error.message })
    }
});


exports.cancelPaymentIntent = functions.https.onRequest(async (req, res) => {
    const paymentIntentId = req.body.paymentIntentId;

    try {
        const paymentIntent = await stripe.paymentIntents.cancel(paymentIntentId);
        //Sends the client the payment intent secret, ephemeral key secret and customer id
        res.status(200).send({
            message: 'Payment intent canceled.'
        })
    } catch (error) {
        console.error(error);
        res.status(404).send({ success: false, error: error.message })
    }
});
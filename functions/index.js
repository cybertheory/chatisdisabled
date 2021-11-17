// The Cloud Functions for Firebase SDK to create
// Cloud Functions and setup triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");

const {bad_words} = require("bad-words");

// const geofirestore = require('geofirestore');
// const {exportBids}   = require('./exportBids');

admin.initializeApp();

// Listens for new messages added to
// /messages/:documentId/original and creates an
// uppercase version of the message to
// /messages/:documentId/uppercase
exports.censor = functions.firestore.
document("/rooms/{roomid}/messages/{documentId}")
.onWrite((snap, context) => {

const message = snap.msg;

if (message && snap.get("sanitized") == null) {
        // Retrieved the message values.
        console.log('Retrieved message content: ', message);

        // Run moderation checks on on the message and moderate if needed.
        const moderatedMessage = moderateMessage(message.text);

        // Update the Firebase DB with checked message.
        console.log('Message has been moderated. Saving to DB: ', moderatedMessage);

        return change.after.ref.update({
        	msg : moderatedMessage,
        	sanitized : true,
        	moderated: message.text !== moderatedMessage
        });

}
});

function moderateMessage(message) {
  // Moderate if the user uses SwearWords.
  if (containsSwearwords(message)) {
    console.log('User is swearing. moderating...');
    message = moderateSwearwords(message);
  }

  return message;
}

// Returns true if the string contains swearwords.
function containsSwearwords(message) {
  return message !== badWordsFilter.clean(message);
}

// Hide all swearwords. e.g: Crap => ****.
function moderateSwearwords(message) {
  return badWordsFilter.clean(message);
}
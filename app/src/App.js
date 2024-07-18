import "./App.css";
import { useState } from "react";

const uuid = require("uuid");
const invoke_url = "https://dtbzs38o7h.execute-api.us-west-2.amazonaws.com/";

function App() {
  const [image, setImage] = useState("");
  const [uploadResultMessage, setUploadResultMessage] = useState(
    "Please upload an image."
  );
  const [name, setName] = useState("placeholder.jpeg");
  const [isAuth, setAuth] = useState(false);

  function sendImage(e) {
    e.preventDefault();
    setName(image.name);
    const imageName = uuid.v4();
    fetch(`${invoke_url}dev/face-recognition-bucket-715/${imageName}.jpeg`, {
      method: "PUT",
      headers: {
        "Content-Type": "image/jpeg",
      },
      body: image,
    })
      .then(async () => {
        const response = await authenticate(imageName);
        if (response.message === "Success") {
          setAuth(true);
          setUploadResultMessage(
            `${response["first_name"]} ${response["last_name"]}`
          );
        } else {
          setAuth(false);
          setUploadResultMessage("Person is not in the system.");
        }
      })
      .catch((error) => {
        setAuth(false);
        setUploadResultMessage("Sorry something went wrong. Please try again.");
        console.error(error);
      });
  }

  async function authenticate(imageName) {
    const requestUrl =
      `${invoke_url}dev/person?` +
      new URLSearchParams({
        objectKey: `${imageName}.jpeg`,
      });
    return await fetch(requestUrl, {
      method: "GET",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
      },
    })
      .then((response) => response.json())
      .then((data) => {
        return data;
      })
      .catch((error) => console.error(error));
  }

  return (
    <div className="App">
      <h2>Facial Recognition System</h2>
      <form on onSubmit={sendImage}>
        <input
          type="file"
          namge="image"
          onChange={(e) => setImage(e.target.files[0])}
        />
        <button type="submit">Check</button>
      </form>
      <div className={isAuth ? "success" : "failure"}>
        {uploadResultMessage}
      </div>
      <img
        src={require(`./people/${name}`)}
        alt="People"
        className="face-image"
      />
    </div>
  );
}

export default App;

import { useState, useEffect } from "react";
// Import your GIF - make sure to put the GIF file in the src/assets folder
import welcomeGif from '../assets/welcome.gif'; // Add your GIF file here

const App = ({ token, setToken }) => {
  return (
    <div className="bg-gray-900 text-gray-100 min-h-screen font-serif">
      <main className="p-12 text-center">
        <h1 className="text-4xl mb-2 font-light">
          Aplikacja zakładu pogrzebowego — Wieczny Spokój
        </h1>
        
        {/* Add the GIF image */}
        <div className="my-8">
          <img 
            src={welcomeGif} 
            alt="Welcome Animation" 
            className="mx-auto rounded-lg shadow-lg max-w-md w-full"
          />
        </div>

        {token ? (
          <p className="text-xl text-gray-300">Zalogowano ✅</p>
        ) : (
          <p className="text-xl text-gray-300">
            Nie jesteś zalogowany. Przejdź do logowania.
          </p>
        )}
      </main>
    </div>
  );
};

export default App;
// Navigation.jsx
import { Link, useNavigate } from "react-router-dom";

const Navigation = ({ token, handleLogout }) => {
  const navigate = useNavigate();
  const userRole = localStorage.getItem("userRole"); // store role

  const handleLogoutClick = () => {
    handleLogout();
    navigate("/log");
  };

  return (
    <nav className="flex gap-4 p-5 bg-gray-800 border-b border-gray-700 justify-center items-center">
      <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/">
        🏠 Home
      </Link>
      {token && (
        <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/profile">
          👤 Profile
        </Link>
      )}
      {token && userRole === 'ADMIN' && (
        <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/admin">
          ⚙️ Admin Panel
        </Link>
      )}
      {token && userRole === 'ADMIN' && (
        <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/raports">
          📊 Raporty
        </Link>
      )}
      {token && (
        <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/tasks">
          📋 Zadania
        </Link>
      )}
      {token && (
        <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/recepcionist">
          📋 Recepcja
        </Link>
      )}
      {token && userRole === 'USER' && (
        <span className="text-gray-500 cursor-not-allowed">
          ⚙️ Admin Panel
        </span>
      )}
      {token && userRole === 'USER' && (
        <span className="text-gray-500 cursor-not-allowed">
          📊 Zamówienia
        </span>
      )}
      {!token && (
        <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/log">
          🔐 Logowanie
        </Link>
      )}
      {token && (
        <button
          className="bg-red-600 hover:bg-red-500 text-white border-none py-2 px-4 rounded cursor-pointer font-medium transition-colors"
          onClick={handleLogoutClick}
        >
          🚪 Wyloguj
        </button>
      )}
    </nav>
  );
};

export default Navigation;
// Navigation.jsx
import { Link } from "react-router-dom";

const Navigation = ({ token, handleLogout, toggleLogPanel }) => {
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
            {token && (
                <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/admin">
                    ⚙️ Admin Panel
                </Link>
            )}
            {token && (
                <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/raports">
                    📊 Raporty
                </Link>
            )}
            {token && (
                <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/recepcionist">
                    📊 Recepcja
                </Link>
            )}
            {token && (
                <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/tasks">
                    📋 Zadania
                </Link>
            )}
            {token && (
                <button
                    className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium"
                    onClick={toggleLogPanel}
                >
                    📜 Logi
                </button>
            )}
            {!token && (
                <Link className="text-purple-400 hover:text-purple-300 transition-colors no-underline font-medium" to="/log">
                    🔐 Logowanie
                </Link>
            )}
            {token && (
                <button
                    className="bg-red-600 hover:bg-red-500 text-white border-none py-2 px-4 rounded cursor-pointer font-medium transition-colors"
                    onClick={handleLogout}
                >
                    🚪 Wyloguj
                </button>
            )}
        </nav>
    );
};

export default Navigation;
// RootLayout.jsx
import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import Navigation from '../layouts/Navigation.jsx';
import LogPanel from '../components/LogPanel.jsx';

const RootLayout = ({ token, setToken }) => {
    const [isLogPanelOpen, setIsLogPanelOpen] = useState(false);

    const handleLogout = () => {
        localStorage.removeItem("token");
        setToken(null);
    };

    const toggleLogPanel = () => {
        setIsLogPanelOpen(!isLogPanelOpen);
    };

    return (
        <div className="flex flex-col min-h-screen bg-gray-900">
            <Navigation
                token={token}
                handleLogout={handleLogout}
                toggleLogPanel={toggleLogPanel}
            />
            <main className="flex-1 p-6 bg-gray-900">
                <Outlet />
            </main>
            <LogPanel
                isOpen={isLogPanelOpen}
                onClose={() => setIsLogPanelOpen(false)}
            />
        </div>
    );
};

export default RootLayout;
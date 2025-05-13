// src/components/LogPanel.jsx
import { useState, useEffect } from 'react';

const LogPanel = ({ isOpen, onClose }) => {
    const [logs, setLogs] = useState([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState('all'); // all, Task, Order, User, Client, etc.
    const [error, setError] = useState(null);

    useEffect(() => {
        if (isOpen) {
            fetchLogs();
        }
    }, [isOpen, filter]);

    const fetchLogs = async () => {
        try {
            setLoading(true);
            setError(null);
            const token = localStorage.getItem('token');
            let url = 'http://localhost:8080/logs';

            if (filter !== 'all') {
                url = `http://localhost:8080/logs/entity/${filter}`;
            }

            console.log('Fetching logs from:', url);

            const response = await fetch(url, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Accept': 'application/json'
                }
            });

            if (!response.ok) {
                const errorText = await response.text();
                console.error(`Error ${response.status}: ${errorText}`);
                setError(`Błąd ${response.status}: Nie można pobrać logów`);
                throw new Error(`Error: ${response.status}`);
            }

            const data = await response.json();
            console.log('Logs received:', data);
            setLogs(data);
        } catch (error) {
            console.error('Error fetching logs:', error);
            setError(`Błąd: ${error.message}`);
        } finally {
            setLoading(false);
        }
    };

    const formatDateTime = (dateTimeStr) => {
        if (!dateTimeStr) return 'N/A';
        const date = new Date(dateTimeStr);
        return date.toLocaleString('pl-PL');
    };

    return (
        <div
            className={`fixed right-0 top-0 h-full bg-gray-800 border-l border-gray-700 overflow-y-auto transition-all duration-300 z-50 ${
                isOpen ? 'w-96' : 'w-0'
            }`}
        >
            {isOpen && (
                <div className="p-4">
                    <div className="flex justify-between items-center mb-4">
                        <h2 className="text-xl font-semibold text-gray-100">Logi systemowe</h2>
                        <button
                            onClick={onClose}
                            className="text-gray-400 hover:text-gray-200"
                        >
                            ✕
                        </button>
                    </div>

                    <div className="mb-4">
                        <select
                            className="w-full bg-gray-700 border border-gray-600 rounded p-2 text-gray-200"
                            value={filter}
                            onChange={(e) => setFilter(e.target.value)}
                        >
                            <option value="all">Wszystkie logi</option>
                            <option value="Task">Zadania</option>
                            <option value="Order">Zamówienia</option>
                            <option value="User">Użytkownicy</option>
                            <option value="Client">Klienci</option>
                        </select>
                    </div>

                    {loading ? (
                        <div className="text-center py-8">
                            <p className="text-gray-400">Ładowanie logów...</p>
                        </div>
                    ) : error ? (
                        <div className="text-center py-8">
                            <p className="text-red-400">{error}</p>
                            <button
                                onClick={fetchLogs}
                                className="mt-2 bg-gray-700 hover:bg-gray-600 text-white px-4 py-2 rounded text-sm"
                            >
                                Spróbuj ponownie
                            </button>
                        </div>
                    ) : logs.length === 0 ? (
                        <div className="text-center py-8">
                            <p className="text-gray-400">Brak logów do wyświetlenia</p>
                        </div>
                    ) : (
                        <div className="space-y-3">
                            {logs.map((log) => (
                                <div key={log.id} className="bg-gray-700 p-3 rounded border-l-4 border-purple-500">
                                    <div className="flex justify-between">
                                        <span className="text-xs text-gray-400">{formatDateTime(log.timestamp)}</span>
                                        <span className="text-xs font-medium bg-purple-700 px-2 py-0.5 rounded text-white">
                      {log.action}
                    </span>
                                    </div>
                                    <p className="text-sm font-medium mt-1 text-gray-200">
                                        {log.entityType} {log.entityId ? `#${log.entityId}` : ''}
                                    </p>
                                    <p className="text-xs text-gray-300 mt-1">{log.details}</p>
                                    {log.user && (
                                        <p className="text-xs text-gray-400 mt-1">
                                            Użytkownik: {log.user.firstName} {log.user.lastName}
                                        </p>
                                    )}
                                </div>
                            ))}
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

export default LogPanel;
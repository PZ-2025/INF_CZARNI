import React, { useEffect, useState } from 'react';

const Profile = () => {
    const [user, setUser] = useState(null);
    const [error, setError] = useState('');

    useEffect(() => {
        const fetchUser = async () => {
            const token = localStorage.getItem('token');
            if (!token) {
                setError('Brak tokenu. Użytkownik nie jest zalogowany.');
                return;
            }

            try {
                const response = await fetch('http://localhost:8080/users/me', {
                    headers: {
                        'Authorization': `Bearer ${token}`
                    }
                });

                if (!response.ok) throw new Error('Nie udało się pobrać danych użytkownika');

                const data = await response.json();
                setUser(data);
            } catch (err) {
                setError(err.message);
            }
        };

        fetchUser();
    }, []);

    if (error) {
        return <div style={styles.error}>{error}</div>;
    }

    if (!user) {
        return <div style={styles.loading}>Ładowanie danych użytkownika...</div>;
    }

    return (
        <div style={styles.container}>
            <h1 style={styles.header}>Profil użytkownika</h1>
            <div style={styles.profileBox}>
                <p><strong>Imię:</strong> {user.firstName}</p>
                <p><strong>Nazwisko:</strong> {user.lastName}</p>
                <p><strong>Email:</strong> {user.email}</p>
                <p><strong>Rola:</strong> {user.role}</p>
            </div>
        </div>
    );
};

const styles = {
    container: {
        padding: '20px',
        maxWidth: '600px',
        margin: '0 auto',
        backgroundColor: '#2a2828',
        color: 'white',
        borderRadius: '8px',
    },
    header: {
        textAlign: 'center',
        color: '#fff',
    },
    profileBox: {
        padding: '20px',
        backgroundColor: '#3a3a3a',
        borderRadius: '8px',
        lineHeight: '1.8',
    },
    loading: {
        color: 'white',
        textAlign: 'center',
        padding: '20px'
    },
    error: {
        color: 'red',
        textAlign: 'center',
        padding: '20px'
    }
};

export default Profile;

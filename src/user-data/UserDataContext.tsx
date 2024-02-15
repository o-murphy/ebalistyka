import React, {createContext, useState, useContext, useEffect} from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

const UserDataContext = createContext(null);

export const useUserData = () => {
    const context = useContext(UserDataContext);
    if (!context) {
        // Optionally, throw an error or return a default value
        console.error('useUserData must be used within a UserDataProvider');
        return {
            userData: null, saveUserData: () => {}
        }; // Example default value
    }
    return context;
};

export const UserDataProvider = ({children}) => {
    const [userData, setUserData] = useState(null);

    // Load user data
    useEffect(() => {
        const loadUserData = async () => {
            try {
                const jsonValue = await AsyncStorage.getItem('@user_data');
                setUserData(jsonValue != null ? JSON.parse(jsonValue) : null);
            } catch (e) {
                console.error('Error loading user data', e);
            }
        };

        loadUserData();
    }, []);

    // Save user data
    const saveUserData = async (data) => {
        try {
            const jsonValue = JSON.stringify(data);
            await AsyncStorage.setItem('@user_data', jsonValue);
            setUserData(data);
        } catch (e) {
            console.error('Error saving user data', e);
        }
    };

    return (
        <UserDataContext.Provider value={{userData, saveUserData}}>
            {children}
        </UserDataContext.Provider>
    );
};
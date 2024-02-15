import React from 'react';
import {Platform, Text} from "react-native";
import {useState} from 'react';
import {StatusBar} from 'expo-status-bar';
import {PaperProvider, MD3LightTheme, MD3DarkTheme} from 'react-native-paper';
import {SafeAreaProvider} from 'react-native-safe-area-context';

import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import {TopAppBar, BotAppBar} from "./src/components/app-bars";
import {MunitionScreen, CurrentAtmo, SettingsScreen, Calculate, Trajectory} from "./src/screens";

import { isMobile } from 'react-device-detect';



import {navigationRef} from "./src/RootNavigation";
import Placeholder from "./src/screens/placeholder/Placeholder";
import RootScreenManager from "./src/RootScreenManager";


const Stack = createNativeStackNavigator();


export default function App() {

    const [nightMode, setNightmode] = useState(true);
    const theme = nightMode ? MD3DarkTheme : MD3LightTheme

    const toggleNightMode = () => {
        setNightmode((prevNightMode) => !prevNightMode);
    };

    const styles = {
        provider: {
            flex: 1,
            backgroundColor: theme.colors.background  // Theme Background Color
        },
    }

    // TODO: make a design for browsers
    if ((Platform.OS === "web") && (!isMobile)) {
        return <Placeholder text={"Oops! The app supports only mobile view"}></Placeholder>
    }

    return (
        <SafeAreaProvider style={styles.provider}>
            <PaperProvider theme={theme}>

                <RootScreenManager nightMode={nightMode} toggleNightMode={toggleNightMode}/>

                <StatusBar style="auto"/>
            </PaperProvider>
        </SafeAreaProvider>
    );
}

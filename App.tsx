// import 'react-native-gesture-handler';
import React from 'react';
import {useState} from 'react';
import {StatusBar} from 'expo-status-bar';
import {PaperProvider, MD3LightTheme, MD3DarkTheme} from 'react-native-paper';
import {SafeAreaProvider} from 'react-native-safe-area-context';

import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';


import TopAppBar from './components/top-app-bar/TopAppBar';
import SettingsScreen from './pages/settings-screen/SettingsScreen';
import HomeScreen from './pages/home-screen/HomeScreen';
import BotAppBar from './components/bot-app-bar/BotAppBar';
// import { createStackNavigator } from '@react-navigation/native-stack';


const Stack = createNativeStackNavigator();


export default function App() {

    const [nightMode, setNightmode] = useState(true);
    const theme = nightMode ? MD3DarkTheme : MD3LightTheme
    // styles.container.backgroundColor = theme.colors.background

    const toggleNightMode = () => {
        setNightmode((prevNightMode) => !prevNightMode);
    };

    const styles = {
        provider: {
            flex: 1,
            backgroundColor: theme.colors.background  // Theme Background Color
            // alignItems: 'center',
            // justifyContent: 'center',
        },
    }

    return (
        <SafeAreaProvider style={styles.provider}>
            <PaperProvider theme={theme}>

                <NavigationContainer>
                    <Stack.Navigator
                        initialRouteName="Home"
                        screenOptions={{
                            header: (props) => <TopAppBar {...props}
                                params={{nightMode, toggleNightMode}}
                            />,
                        }}
                    >

                        <Stack.Screen name="Home" component={HomeScreen} />

                        <Stack.Screen name="Settings" component={SettingsScreen} />

                    </Stack.Navigator>

                </NavigationContainer>

                <BotAppBar/>


                <StatusBar style="auto"/>
            </PaperProvider>
        </SafeAreaProvider>
    );
}

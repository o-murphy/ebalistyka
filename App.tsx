// import 'react-native-gesture-handler';
import React from 'react';
import {useState} from 'react';
import {StatusBar} from 'expo-status-bar';
import {PaperProvider, MD3LightTheme, MD3DarkTheme} from 'react-native-paper';
import {SafeAreaProvider} from 'react-native-safe-area-context';

import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';


import TopAppBar from './src/components/top-app-bar/TopAppBar';
import SettingsScreen from './src/screens/settings/SettingsScreen';
import HomeScreen from './src/screens/home/HomeScreen';
import CurrentAtmo from "./src/screens/atmo/CurrentAtmo";
import BotAppBar from './src/components/bot-app-bar/BotAppBar';


import {navigationRef} from "./src/RootNavigation";


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

                <NavigationContainer ref={navigationRef}>
                    <Stack.Navigator
                        initialRouteName="Home"
                        screenOptions={{
                            header: (props) => <TopAppBar {...props}
                                                          params={{nightMode, toggleNightMode}}
                            />,
                        }}
                    >

                        <Stack.Screen name="Home" component={HomeScreen}/>
                        <Stack.Screen name="Atmosphere" component={CurrentAtmo}/>
                        <Stack.Screen name="Settings" component={SettingsScreen}/>


                    </Stack.Navigator>
                    <BotAppBar/>

                </NavigationContainer>


                <StatusBar style="auto"/>
            </PaperProvider>
        </SafeAreaProvider>
    );
}

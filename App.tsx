import React from 'react';
import {useState} from 'react';
import {StatusBar} from 'expo-status-bar';
import {PaperProvider, MD3LightTheme, MD3DarkTheme} from 'react-native-paper';
import {SafeAreaProvider} from 'react-native-safe-area-context';

import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import {TopAppBar, BotAppBar} from "./src/components/app-bars";
import {HomeScreen, CurrentAtmo, SettingsScreen} from "./src/screens";


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

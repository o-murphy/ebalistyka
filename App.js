import { useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View, ScrollView, Dimensions } from 'react-native';
import { PaperProvider, MD3LightTheme, MD3DarkTheme } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import TopAppBar from './components/top-app-bar/TopAppBar';
import SettingsPage from './pages/settings-page/SettingsPage';
import BotAppBar from './components/bot-app-bar/BotAppBar';


const windowHeight = Dimensions.get('window').height;

const styles = StyleSheet.create({
  scrollViewContainer: {
    height: windowHeight * 0.8, // Set the height as a percentage of the screen height
    marginBottom: 80
  },
});


export default function App() {

  const [nightMode, setNightmode] = useState(true);
  const theme = nightMode ? MD3DarkTheme : MD3LightTheme
  // styles.container.backgroundColor = theme.colors.background

  const toggleNightMode = () => {
    setNightmode((prevNightMode) => !prevNightMode);
  };

  const containerStyle = {
    flex: 1,
    backgroundColor: theme.colors.background /* Your Light Theme Background Color */
    // alignItems: 'center',
    // justifyContent: 'center',
  };

  return (
    <SafeAreaProvider style={containerStyle}>
      <PaperProvider theme={theme}>
        <TopAppBar props={{nightMode: nightMode, toggleNightMode: toggleNightMode}} />

            <ScrollView style={styles.scrollViewContainer}
              keyboardShouldPersistTaps="always"
              alwaysBounceVertical={false}
              showsVerticalScrollIndicator={true}
            >
              <SettingsPage />
            </ScrollView>

        {/* <SettingsPage /> */}
        <BotAppBar />
        <StatusBar style="auto" />
      </PaperProvider>
    </SafeAreaProvider>
  );
}

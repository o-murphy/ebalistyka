import { StatusBar } from 'expo-status-bar';
import { StyleSheet, View, ScrollView, Dimensions } from 'react-native';
import { PaperProvider, MD3DarkTheme } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import TopAppBar from './components/top-app-bar/TopAppBar';
import SettingsPage from './pages/settings-page/SettingsPage';
import BotAppBar from './components/bot-app-bar/BotAppBar';

export default function App() {
  return (
    <SafeAreaProvider style={styles.container}>
      <PaperProvider theme={MD3DarkTheme}>
        <TopAppBar />

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

const windowHeight = Dimensions.get('window').height;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: MD3DarkTheme.colors.background,
    // alignItems: 'center',
    // justifyContent: 'center',
  },
  scrollViewContainer: {
    height: windowHeight * 0.8, // Set the height as a percentage of the screen height
    marginBottom: 72
  },
});

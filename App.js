import { StatusBar } from 'expo-status-bar';
import { StyleSheet, Text, SafeAreaView, Alert } from 'react-native';
import { PaperProvider, Button } from 'react-native-paper';
import { SafeAreaProvider } from 'react-native-safe-area-context';

import TopAppBar from './components/TopAppBar';

export default function App() {

  const handleTextPress = () => console.log("Hello")
  const handleBtnPress = () => Alert.alert("Btn", "Message",
    { text: "OK", onPress: () => console.log("OK") },
    { text: "Cancel", onPress: () => console.log("Cancel") },
  )

  return (
    <SafeAreaProvider style={styles.container}>
      <PaperProvider>
        <TopAppBar />
        <Text onPress={handleTextPress}>Hello!</Text>
        <Button icon="camera" mode="elevated" onPress={() => console.log('Pressed')}>
          Press me
        </Button>
        <StatusBar style="auto" />
      </PaperProvider>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    // alignItems: 'center',
    // justifyContent: 'center',
  },
});

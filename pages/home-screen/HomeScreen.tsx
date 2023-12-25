import React from "react";
import {View} from 'react-native';
import { Button, Text} from 'react-native-paper';
import {StyleSheet} from "react-native";

export default function HomeScreen({ navigation }) {

    const style = StyleSheet.create({
        container: {
            flex: 1,
            alignItems: 'center',
            justifyContent: 'center',
        },
    });

    return (
        <View style={style.container}>
            <Text>Settings</Text>
            <Button mode="elevated" onPress={() => navigation.navigate('Settings')}>
                Go to settings
            </Button>
        </View>
    );
}

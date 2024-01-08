import React from "react";
import {ScrollView} from 'react-native';
import {useTheme, Text} from 'react-native-paper';
import {StyleSheet} from "react-native";


export default function Placeholder({text}: { text?: string }) {

    const theme = useTheme();

    const styles = StyleSheet.create({
        scrollViewContainer: {
            backgroundColor: theme.colors.background,
        },
    });

    return (
        <ScrollView
            style={styles.scrollViewContainer}
            keyboardShouldPersistTaps="always"
            alwaysBounceVertical={false}
            showsVerticalScrollIndicator={true}

            contentContainerStyle={{
                flex: 1,
                justifyContent: 'center',
            }}
        >
            <Text style={{textAlign: "center"}}>{text ? text : "Not implemented yet"}</Text>
        </ScrollView>
    );
}

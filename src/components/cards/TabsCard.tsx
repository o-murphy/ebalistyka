import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import Placeholder from "../../screens/placeholder/Placeholder";
import {Card} from "react-native-paper";
import styleSheet from "../../styles";

const Stack = createNativeStackNavigator();

export default function TabsCard() {
    return (

        <Card mode="elevated" elevation={1}
              style={[styleSheet.card.card]}
        >
            <Card.Title titleVariant={"titleLarge"} title={"Page"}></Card.Title>
            <Card.Content style={styleSheet.card.content}>
                <NavigationContainer independent={true}>
                    <Stack.Navigator initialRouteName="Page1">
                        <Stack.Screen name="Page1" component={Placeholder} />
                        <Stack.Screen name="Page2" component={Placeholder} />
                    </Stack.Navigator>
                </NavigationContainer>
            </Card.Content>
        </Card>


    );
}
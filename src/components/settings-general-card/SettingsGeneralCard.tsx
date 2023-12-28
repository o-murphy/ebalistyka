import {Card, Text, useTheme} from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import {Col, Grid, Row} from "react-native-paper-grid";

import {StyleSheet, View} from "react-native";


export default function SettingsGeneralCard() {

    const theme = useTheme();

    const styles = StyleSheet.create({
        grid: {
            flex: 1,
        },
        row: {
            flex: 1,
            alignItems: "center",
        },
        col: {
            flex: 1,
        },
    });

    return (

        <Card mode="elevated" elevation={1} style={{margin: 10, padding: 5}}>
            <Card.Title title="General"/>

            <Card.Content style={{marginHorizontal: 0, paddingHorizontal: 10}}>


                <Grid style={styles.grid}>

                    <Row style={styles.row}>
                        <Col>
                            <Text variant="titleMedium" >Language</Text>
                        </Col>
                        <Col>
                            <LanguagePicker/>
                        </Col>
                    </Row>

                </Grid>


            </Card.Content>
        </Card>

    )

}
import {Text} from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";

export default function SettingsGeneralCard() {


    return (
        <InputCard title={"General"}>
            <Grid style={styleSheet.grid.grid}>

                <Row style={styleSheet.grid.row}>
                    <Col>
                        <Text >Language</Text>
                    </Col>
                    <Col>
                        <LanguagePicker/>
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )

}
import {Text} from "react-native-paper"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import {useState} from "react";
import RadioGroup from "../radio-group/RadioGroup";

export default function SettingsGeneralCard() {

    const languageList = [
        {
            label: "English",
            value: "EN",
            key: "EN"
        },
        {
            label: "Ukrainian",
            value: "UA",
            key: "UA"
        },
    ];

    const [curLanguage, setCurLanguage] = useState("EN");
    const [language, setLanguage] = useState(curLanguage);

    const acceptLanguage = () => {
        setCurLanguage(language)
    }

    return (
        <InputCard title={"General"}>
            <Grid style={styleSheet.grid.grid}>

                <Row style={styleSheet.grid.row}>
                    <Col size={9}>
                        <Text>{"Language"}</Text>
                    </Col>
                    <Col size={7}>
                        <SimpleModal title={"Language"} text={curLanguage} icon={"translate"} onAccept={acceptLanguage}>
                            <RadioGroup value={language} setValue={setLanguage} items={languageList} />
                        </SimpleModal>
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )

}
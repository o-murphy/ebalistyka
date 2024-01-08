import {Text} from "react-native-paper"
import {Col, Grid, Row} from "react-native-paper-grid";
import InputCard from "./InputCard";
import styleSheet from "../../styles";

import SimpleDialog from "../simple-modal/SimpleDialog";
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

    const onAccept = () => {
        setCurLanguage(language)
    }

    const onDecline = () => {
        setLanguage(curLanguage)
    }

    return (
        <InputCard title={"General"}>
            <Grid style={styleSheet.grid.grid}>

                <Row style={styleSheet.grid.row}>
                    <Col size={9}>
                        <Text style={{fontSize: 16}}>{"Language"}</Text>
                    </Col>
                    <Col size={7}>
                        <SimpleDialog title={"Language"} text={curLanguage} icon={"translate"}
                                      onAccept={onAccept}
                                      onDecline={onDecline}>
                            <RadioGroup initialValue={language} onChange={setLanguage} items={languageList} />
                        </SimpleDialog>
                    </Col>
                </Row>

            </Grid>
        </InputCard>
    )

}
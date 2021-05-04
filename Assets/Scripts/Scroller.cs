using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scroller : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        m_MovementSpeed = BPM;
        transform.position = new Vector3 (0, 0, 670);
    }

    // Update is called once per frame
    void Update()
    {
        transform.position -= new Vector3(0.0f, 0.0f, m_MovementSpeed * Time.deltaTime * GameManager.speedOffset);
    }

    public int BPM;
    private float m_MovementSpeed;
}
